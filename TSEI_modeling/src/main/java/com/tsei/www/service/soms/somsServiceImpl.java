package com.tsei.www.service.soms;

import java.util.List;

import com.tsei.www.mapper.no1.somsMapper;
import com.tsei.www.vo.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class somsServiceImpl implements somsService {

    @Autowired
    private somsMapper mapper;

    @Override
    public List<modelingDataVO> getModelingList(String startTime, String endTime, int e_idx, int c_idx)
            throws Exception {
        return mapper.getModelingList(startTime, endTime, e_idx, c_idx);
    }

    @Override
    public List<placeDataVO> getPlaceList() throws Exception {
        return mapper.getPlaceList();
    }

    @Override
    public List<modelingWeatherVO> getWeatherList(String startTime, String endTime) throws Exception {
        return mapper.getWeatherList(startTime, endTime);
    }

    @Override
    public String[] getModelingDate() throws Exception {
        return mapper.getModelingDate();
    }

    @Override
    public List<modelingDataVO> getAconcList(int e_index, double latm, double latp, double lonm, double lonp,
            String startTime, String endTime, String conc) throws Exception {
        return mapper.getAconcList(e_index, latm, latp, lonm, lonp, startTime, endTime, conc);
    }
}
