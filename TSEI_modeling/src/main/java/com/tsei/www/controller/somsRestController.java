package com.tsei.www.controller;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.tsei.www.service.soms.somsService;

@RestController
@RequestMapping("/soms")
public class somsRestController {

    @Autowired
    private somsService service;

    @GetMapping("/date")
    public String[] getModelingDate() throws Exception {
        String[] mDate = service.getModelingDate();
        return mDate;
    }

    @GetMapping("/places")
    public Map<String, Object> getPlaceList() throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("list", service.getPlaceList());
        return map;
    }

    @GetMapping("/dataList")
    public Map<String, Object> getModelingList(@RequestParam(value = "selectDate") String selectDate,
            @RequestParam(value = "selectTime") String selectTime, @RequestParam(value = "e_idx") int e_idx,
            @RequestParam(value = "c_idx") int c_idx)
            throws Exception {
    	if(selectDate.equals("undefined")) {
    		selectDate = LocalDate.now(ZoneId.of("Asia/Seoul")).toString();
    	}
        String firstAddTime = ":00:00";
        String secondAddTime = ":59:59";
        String startTime = selectDate + " " + selectTime + firstAddTime;
        String endTime = selectDate + " " + selectTime + secondAddTime;

        Map<String, Object> map = new HashMap<String, Object>();

        map.put("list", service.getModelingList(startTime, endTime, e_idx, c_idx));

        return map;
    }

    @GetMapping("/weatherList")
    public Map<String, Object> getWeatherList(@RequestParam(value = "selectDate") String selectDate,
            @RequestParam(value = "selectTime") String selectTime) throws Exception {
    	if(selectDate.equals("undefined")) {
    		selectDate = LocalDate.now(ZoneId.of("Asia/Seoul")).toString();
    	}
    	String firstAddTime = ":00:00";
        String secondAddTime = ":59:59";
        String startTime = selectDate + " " + selectTime + firstAddTime;
        String endTime = selectDate + " " + selectTime + secondAddTime;

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("list", service.getWeatherList(startTime, endTime));
        return map;
    }

    @GetMapping("/aplaceList")
    public Map<String, Object> getAconcList(@RequestParam(value = "e_index") int e_index,
            @RequestParam(value = "lat") double lat,
            @RequestParam(value = "lon") double lon, @RequestParam(value = "selectDate") String selectDate,
            @RequestParam(value = "selectTime") String selectTime, @RequestParam(value = "conc") String conc)
            throws Exception {
    	if(selectDate.equals("undefined")) {
    		selectDate = LocalDate.now(ZoneId.of("Asia/Seoul")).toString();
    	}
    	String firstAddTime = ":00:00";
        String secondAddTime = ":59:59";
        String startTime = selectDate + " " + selectTime + firstAddTime;
        String endTime = selectDate + " " + selectTime + secondAddTime;
        Double errorw = 0.000449;
        Double errorh = 0.000549;
        String concFinal = "conc" + conc;

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("list", service.getAconcList(e_index, lat - errorw, lat + errorw, lon - errorh, lon + errorh, startTime,
                endTime, concFinal));

        return map;
    }
}
