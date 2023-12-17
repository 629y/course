package com.course.server.enums;

public enum SectionChargeEnum {
    //直接写“C” 还有一个缺点，就是从代码上看不出来“C”是什么意思，后期很难维护。
    //枚举名称是给开发人员用的，code 是给程序用的，desc 是给用户用的。
    //从前后端数据传输，到数据库存储，都是用的C或F
    CHARGE("C","收费"),
    FREE("F","免费");
    private String code;
    private String desc;

    SectionChargeEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }
}
