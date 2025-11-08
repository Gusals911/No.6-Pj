package com.tsei.www.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class modelingWeatherVO {

    private double wind_dir = 0.0;
    private double wind_spd = 0.0;
    private double temp = 0.0;
    private double humi = 0.0;
    private double pressure = 0.0;
    private double sun = 0.0;
    private String reg_date;

}
