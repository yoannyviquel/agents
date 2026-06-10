// Chain of Responsibility — pass a request along a chain of handlers.

abstract class Handler {
    private Handler next;
    Handler linkTo(Handler next) { this.next = next; return next; }

    String handle(int amount) {
        if (next != null) return next.handle(amount);
        return "rejected: no approver for " + amount;
    }
}

class TeamLead extends Handler {
    String handle(int amount) {
        if (amount <= 100) return "TeamLead approved " + amount;
        return super.handle(amount);
    }
}

class Manager extends Handler {
    String handle(int amount) {
        if (amount <= 1000) return "Manager approved " + amount;
        return super.handle(amount);
    }
}

class Director extends Handler {
    String handle(int amount) {
        if (amount <= 10000) return "Director approved " + amount;
        return super.handle(amount);
    }
}

public class ChainOfResponsibility {
    public static void main(String[] args) {
        Handler chain = new TeamLead();
        chain.linkTo(new Manager()).linkTo(new Director());

        for (int amount : new int[] { 50, 500, 5000, 50000 }) {
            System.out.println(chain.handle(amount));
        }
    }
}
