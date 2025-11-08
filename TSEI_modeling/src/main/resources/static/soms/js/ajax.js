// 모델링 데이터 요청
// 매개변수(고도, 날짜, 시간, 사업장)
const modeling_ajax = () => {
	$.ajax({
		url:
			'/soms/dataList?selectDate=' +
			selectDate +
			'&selectTime=' +
			selectTime +
			'&e_idx=' +
			company +
			'&c_idx=' +
			altitude,
		type: 'GET',
		async: false,
		success: function (data) {
			console.log(company, '에 대한 모델링 데이터 요청', data.list);
			let list = data.list;
			conc_color(list);

			$('#tbody1').replaceWith("<tbody id='tbody1'></tbody>");
			$('#tbody2').replaceWith("<tbody id='tbody2'></tbody>");
			$('#tbody3').replaceWith("<tbody id='tbody3'></tbody>");
		},
		error: function (e) {
			console.log(e);
			alert('모델링 데이터가 존재하지 않습니다.');
			//location.reload();
		},
	});
};

const get_placeData = () => {
	//장소 데이터 불러오기
	var placesData;
	$.ajax({
		url: '/soms/places',
		type: 'GET',
		async: false,
		success: function (result) {
			placesData = result.list;
			placesData.sort((a, b) => a.p_index - b.p_index);
		},
		error: function (e) {
			console.log(e);
			alert('장소 데이터 불러오기 오류');
			location.reload();
		},
	});
	return placesData;
};

// 모델링 날짜 정보 요청
const modelingDate_ajax = () => {
	$.ajax({
		url: '/soms/date',
		type: 'GET',
		async: false,
		success: function (result) {
			create_date(result);
			set_date();
		},
		error: function (e) {
			console.log(e);
			alert('데이터가 존재하지 않습니다.');
			//location.reload();
		},
	});
};

/* 영향 주는 사업장 탐색 ajax  company(0=전체)), lat, lat, lon, lon, date, time, altitude */
function affected_ajax2(company, lat, lon) {
	var list = [];
	$.ajax({
		url:
			'/soms/aplaceList?e_index=' +
			company +
			'&lat=' +
			lat +
			'&lon=' +
			lon +
			'&selectDate=' +
			selectDate +
			'&selectTime=' +
			selectTime +
			'&conc=' +
			altitude,
		type: 'GET',
		async: false,
		success: function (data) {
			list = data.list;
		},
		error: function (e) {
			console.log(e);
			alert('Error: Loading Affected Places');
		},
	});
	if (list) return list;
}

function getPointConc(lat, lon) {
	var data = affected_ajax2(0, lat, lon);
	if (data.length > 0) return data[0]['conc'].toFixed(2);
	else return '0';
}

function getAffectedList(lat, lon) {
	var returnArr = [];
	var company_size = placesData.length;

	for (var i = 1; i <= company_size; i++) {
		var data = affected_ajax2(i, lat, lon);
		if (data.length > 0) {
			returnArr.push({ key: findPlace(i), value: data[0]['conc'].toFixed(2) });
			affectedPlaces.push(i);
		}
	}
	return returnArr;
}

function findPlace(p_index) {
	for (var i = 0; i < placesData.length; i++) {
		if (placesData[i]['p_index'] == p_index) {
			return placesData[i].name;
		}
	}
}

function weather_Ajax() {
	var data;
	$.ajax({
		url: '/soms/weatherList?selectDate=' + selectDate + '&selectTime=' + selectTime,
		type: 'GET',
		async: false,
		success: function (result) {
			data = result.list[0];
		},
		error: function (e) {
			console.log(e);
		},
	});
	return data;
}
