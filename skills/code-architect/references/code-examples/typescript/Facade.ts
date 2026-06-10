// Facade — a simplified interface over a complex subsystem.

class VideoDecoder {
  decode(file: string): string {
    return `frames(${file})`;
  }
}

class AudioMixer {
  mix(file: string): string {
    return `audio(${file})`;
  }
}

class SubtitleLoader {
  load(file: string): string {
    return `subs(${file})`;
  }
}

// Facade hides subsystem wiring behind one method.
class MediaPlayerFacade {
  private decoder = new VideoDecoder();
  private mixer = new AudioMixer();
  private subtitles = new SubtitleLoader();

  play(file: string): string {
    const video = this.decoder.decode(file);
    const audio = this.mixer.mix(file);
    const subs = this.subtitles.load(file);
    return `playing -> ${video} + ${audio} + ${subs}`;
  }
}

function demo(): void {
  const player = new MediaPlayerFacade();
  console.log(player.play("movie.mkv"));
}

demo();
