package domain.info;

import com.fasterxml.jackson.annotation.JsonFormat;

@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public interface Info {
    String getInfoTypeName();
    boolean getResult();
    int getCode();
    String getMessage();
}
