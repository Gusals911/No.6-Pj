package com.tsei.www.service.soms;

import java.util.List;

import com.tsei.www.vo.*;

public interface somsService {

        public List<modelingDataVO> getModelingList(String startTime, String endTime, int e_idx, int c_idx)
                        throws Exception;

        public List<placeDataVO> getPlaceList() throws Exception;

        public List<modelingWeatherVO> getWeatherList(String startTime, String endTime) throws Exception;

        public String[] getModelingDate() throws Exception;

        public List<com.tsei.www.vo.modelingDataVO> getAconcList(int e_index, double latm, double latp, double lonm,
                        double lonp, String startTime, String endTime, String conc) throws Exception;
}
