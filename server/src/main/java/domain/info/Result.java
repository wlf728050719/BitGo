package domain.info;

public class Result {
    private final Info info;
    private final Object value;
    public Result(Info info, Object value) {
        this.info = info;
        this.value = value;
    }

    public Info getInfo() {
        return info;
    }
    public Object getValue() {
        return value;
    }
}
