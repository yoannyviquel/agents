#!/usr/bin/env node
/**
 * Stop hook — score gate.
 *
 * Blocks the orchestrator from handing control back to the user when a dev
 * agent delivered during this turn without being scored. The subagent itself
 * cannot run the gate: it has no AskUserQuestion tool and its SubagentStop
 * hook only blocks the subagent's own loop. The main session is the only
 * place where the user can actually be asked.
 *
 * Proof the gate ran = an AskUserQuestion tool_use more recent than the Task
 * tool_use that spawned the dev agent. No extra marker needed.
 *
 * Never breaks a session: any failure exits 0 silently.
 */
import { readFileSync, writeFileSync, existsSync, mkdirSync } from "node:fs";
import { join } from "node:path";
import { tmpdir } from "node:os";

const DEV_AGENTS = [
  "dotnet-developer",
  "react-developer",
  "nodejs-developer",
  "ios-game-developer",
];

const STATE_DIR = join(tmpdir(), "yy-score-gate");

/** Read the whole stdin as a string. */
async function readStdin() {
  const chunks = [];
  for await (const chunk of process.stdin) chunks.push(chunk);
  return Buffer.concat(chunks).toString("utf8");
}

/** Parse a JSONL transcript, skipping unparseable lines. */
function parseTranscript(path) {
  return readFileSync(path, "utf8")
    .split("\n")
    .flatMap((line) => {
      if (!line.trim()) return [];
      try {
        return [JSON.parse(line)];
      } catch {
        return [];
      }
    });
}

/** Flatten a message content field to an array of blocks. */
function blocks(entry) {
  const content = entry?.message?.content;
  return Array.isArray(content) ? content : [];
}

/** Stringify a tool_result content field, which may be a string or blocks. */
function resultText(content) {
  if (typeof content === "string") return content;
  if (!Array.isArray(content)) return "";
  return content.map((b) => (typeof b === "string" ? b : b?.text ?? "")).join("\n");
}

/**
 * Last dev-agent Task call and last AskUserQuestion call, by position.
 * The agent tool is recorded as "Task"; "Agent" is accepted defensively.
 */
function scan(entries) {
  let task = null;
  let askedAt = -1;

  entries.forEach((entry, i) => {
    for (const block of blocks(entry)) {
      if (block.type !== "tool_use") continue;
      if (block.name === "AskUserQuestion") askedAt = i;
      if (block.name !== "Task" && block.name !== "Agent") continue;
      const agent = block.input?.subagent_type ?? "";
      const match = DEV_AGENTS.find((a) => agent.includes(a));
      if (match) task = { at: i, id: block.id, agent: match };
    }
  });

  return { task, askedAt };
}

/** The SCORE-GATE block the dev agent appended to its final report. */
function gateBlock(entries, toolUseId) {
  for (const entry of entries) {
    for (const block of blocks(entry)) {
      if (block.type !== "tool_result" || block.tool_use_id !== toolUseId) continue;
      const match = /SCORE-GATE:[\s\S]*/.exec(resultText(block.content));
      if (match) return match[0].slice(0, 1500).trim();
    }
  }
  return null;
}

/**
 * True the first time this exact Task is seen, false afterwards.
 * Guarantees the gate blocks at most once per delivery — a Stop hook that
 * keeps blocking an uncooperative orchestrator is a dead session.
 */
function claimOnce(sessionId, toolUseId) {
  try {
    mkdirSync(STATE_DIR, { recursive: true });
    const file = join(STATE_DIR, `${sessionId}.txt`);
    if (existsSync(file) && readFileSync(file, "utf8").trim() === toolUseId) return false;
    writeFileSync(file, toolUseId);
    return true;
  } catch {
    return false; // cannot guarantee once-only → do not block at all
  }
}

function reason(agent, candidates) {
  return [
    `Le sous-agent \`${agent}\` a livré sans gate de scoring. Avant de rendre la main, lance un seul AskUserQuestion à deux questions :`,
    ``,
    `**Q1 — header "Score"** : "Qualité de la livraison ${agent} ?"`,
    `  4 — parfait (mergeable tel quel) · 3 — retouches (ajustements mineurs) · 2 — corrections (reprise significative) · 1 — à refaire (inutilisable)`,
    ``,
    `**Q2 — header "Apprentissage"**, multiSelect : "Que dois-je retenir ?"`,
    `  Options = les candidats du bloc SCORE-GATE ci-dessous + "Rien à retenir". L'utilisateur peut toujours saisir le sien via "Other".`,
    ``,
    candidates
      ? `Bloc SCORE-GATE remonté par l'agent :\n\`\`\`\n${candidates}\n\`\`\``
      : `⚠️ L'agent n'a pas remonté de bloc SCORE-GATE. Propose toi-même 2-3 candidats d'après ce que la tâche a révélé.`,
    ``,
    `Puis : si score ≤ 2 OU au moins un apprentissage retenu, append une ligne par apprentissage dans \`skills/${agent}/LEARNINGS.md\` (table existante, date du jour, tag court). Sinon n'écris rien. Enfin, rends la main.`,
  ].join("\n");
}

const input = JSON.parse(await readStdin());
const entries = parseTranscript(input.transcript_path);
const { task, askedAt } = scan(entries);

// No dev agent this session, or already scored after it → nothing to do.
if (!task || askedAt > task.at) process.exit(0);
if (!claimOnce(input.session_id, task.id)) process.exit(0);

console.log(
  JSON.stringify({
    decision: "block",
    reason: reason(task.agent, gateBlock(entries, task.id)),
  })
);
