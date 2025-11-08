package com.tsei.www.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class placeDataVO {

    private double lat = 0.0;
    private double lon = 0.0;

    private int p_index = 0;
    private int poi;
    private String name = "Unknown";

}
