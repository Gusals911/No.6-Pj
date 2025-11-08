const modeling_fn = () => {
	animation_show();
	if ((search_val = search_fn('selectDate') === false)) {
		return false;
	}
	if ((search_val = search_fn('selectTime') === false)) {
		return false;
	}
	selectDate = $('#selectDate option:selected').val();
	selectTime = $('#selectTime option:selected').val();
	altitude = $('#selectAltitude option:selected').val();

	//initMap();
	setTimeout(() => {
		modeling_ajax();
		setFAconcAll();
		getWeather_Search();
		animation_hide();
	}, 100);
};

function change_company(val) {
	company = val;
}

function setFAconcAll() {
	setFAconcName();
	setFAconcValue();
	createFATable();
	markerCreate();
}

function setModalconcAll(lat, lng) {
	set_modal_conc(lat, lng);
	createTable_modal(lat, lng);
}

/* 왼쪽 메뉴에 뜨는 관심지점 별 악취 세기 설정 */
function setFAconcName() {
	$('#faconc1name').replaceWith("<p id='faconc1name'>" + placesData[0]['name'] + '</p>');
	$('#faconc2name').replaceWith("<p id='faconc2name'>" + placesData[1]['name'] + '</p>');
	$('#faconc3name').replaceWith("<p id='faconc3name'>" + placesData[2]['name'] + '</p>');
}

function setFAconcValue() {
	for (var i = 0; i < 3; i++) {
		var lat = placesData[i]['lat'];
		var lon = placesData[i]['lon'];
		var concValue = getPointConc(lat, lon);
		$(`#faconc${i + 1}`).replaceWith(`<p id='faconc${i + 1}'>악취 세기 ${concValue}</p>`);
	}
}

/* 관심지점 별 영향사업장 4개 생성 */
function createFATable() {
	for (var i = 0; i < 3; i++) {
		var lat = placesData[i]['lat'];
		var lon = placesData[i]['lon'];
		var arr = getAffectedList(lat, lon);
		arr.sort((a, b) => b.value - a.value);
		var sum = parseFloat(getSumConc(arr));
		console.log('arr: ', arr);
		for (var j = 0; j < arr.length; j++) {
			if (arr[j].key.length > 4) {
				nameShort = arr[j].key.slice(0, 4) + '..';
			} else {
				nameShort = arr[j].key;
			}
			let tableTd = '<tr>';
			tableTd +=
				'<td title=' +
				arr[j].key +
				'><a href="#"><i class="fa-solid fa-arrow-right-to-bracket"></i></a>' +
				nameShort +
				'</td>';
			tableTd += '<td>' + '배출구 - 1' + '</td>';
			tableTd += '<td>' + arr[j].value + '</td>';
			tableTd += '<td>' + ((arr[j].value / sum) * 100).toFixed(2) + '</td>';
			tableTd += '</tr>';

			$(`#tbody${i + 1}`).append(tableTd);
		}
	}
	animation_hide();
}

function getSumConc(arr) {
	var sum = 0.0;
	for (var i = 0; i < arr.length; i++) {
		sum += parseFloat(arr[i].value);
	}
	return sum;
}
/* 맵 상 클릭했을 때 뜨는 모달창 악취 세기 설정 */
function set_modal_conc(lat, lng) {
	var data = getPointConc(lat, lng);
	if (data.length == 0) {
		$('#faconc_modal').replaceWith("<p id='faconc_modal'>악취세기 0</p>");
	} else {
		$('#faconc_modal').replaceWith("<p id='faconc_modal'>악취세기 " + data + '</p>');
	}
}

// 맵 상 클릭했을 때 뜨는 모달창 테이블 생성 함수
function createTable_modal(lat, lng) {
	$('#tbody_modal').replaceWith("<tbody id='tbody_modal'></tbody>");
	var data = getAffectedList(lat, lng);
	data.sort((a, b) => b.value - a.value);
	var sum = parseFloat(getSumConc(data));
	for (var i = 0; i < data.length; i++) {
		if (data[i].key.length > 4) {
			nameShort = data[i].key.slice(0, 4) + '..';
		} else {
			nameShort = data[i].key;
		}
		let tableTd = '<tr>';
		tableTd +=
			'<td title=' +
			data[i].key +
			'><a href="#"><i class="fa-solid fa-arrow-right-to-bracket"></i></a>' +
			nameShort +
			'</td>';
		tableTd += '<td>' + '배출구 - 1' + '</td>';
		tableTd += '<td>' + data[i].value + '</td>';
		tableTd += '<td>' + ((data[i].value / sum) * 100).toFixed(2) + '</td>';
		tableTd += '</tr>';

		$('#tbody_modal').append(tableTd);
	}
}
function getWeather_Search() {
	var data = weather_Ajax();
	$('#searchTemp').text((data.temp - 273.15).toFixed(1) + '℃');
	$('#searchHumi').text(data.humi + '％');
	$('#searchSpeed').text(data.wind_spd + '㎧');
	$('#searchDirection').text(transfer_WindKO(data.wind_dir));
	console.log(transfer_WindKO(data.wind_dir));
	$('#selected_time').text(selectDate + ' ' + selectTime + '시 기상정보');
	//$('#arrows').attr('class', 'arrow ' + transfer_WindENG(data.wind_dir));
	$('#searchWind').attr('class', 'wind ' + transfer_WindENG(data.wind_dir));
}
function getWeather_Realtime() {
	let today = new Date();
	let year = today.getFullYear();
	let month = today.getMonth() + 1;
	if (month < 10) {
		month = '0' + month;
	}
	let date = today.getDate();
	if (date < 10) {
		date = '0' + date;
	}
	let hours = today.getHours() - 1;
	if (hours < 10) {
		hours = '0' + hours;
	}
	hours = hours + '00';

	var data = weather_Ajax();
	console.log(data);
	$('#nowTemp').text((data.temp - 273.15).toFixed(1) + '℃');
	$('#nowHumi').text(data.humi + '％');
	$('#nowSpeed').text(data.wind_spd + '㎧');
	$('#nowDirection').text(transfer_WindKO(data.wind_dir));
	$('#nowDate').text(year + '-' + month + '-' + date);
	$('#arrows').attr('class', 'arrow ' + transfer_WindENG(data.wind_dir));
	$('#wind').attr('class', 'wind ' + transfer_WindENG(data.wind_dir));
}

/*라디안을 한글로*/
function transfer_WindKO(deg) {
	var val = Math.floor(deg / 22.5 + 0.5);
	arr = [
		'북',
		'북북동',
		'북동',
		'동북동',
		'동',
		'동남동',
		'남동',
		'남남동',
		'남',
		'남남서',
		'남서',
		'서남서',
		'서',
		'서북서',
		'북서',
		'북북서',
	];
	return arr[val % 16];
}

/*라디안을 영어로*/
function transfer_WindENG(deg) {
	var val = Math.floor(deg / 22.5 + 0.5);
	arr = ['N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'];
	return arr[val % 16];
}

// 날짜 / 시간 조회 스크립트
const search_fn = (select) => {
	if ($('#' + select).val() === '0') {
		alert($('#' + select + ' option:selected').text() + '를(을) 선택해주세요.');
		return false;
	}
};

//드랍다운
$('.dropdown li').hover(
	function () {
		$('ul', this).stop().slideDown(200);
	},
	function () {
		$('ul', this).stop().slideUp(200);
	}
);

function modal_show(latlng, div) {
	document.querySelector('.background').className = 'background show';
	let ll = JSON.stringify(latlng);
	$('#tbody_modal').replaceWith("<tbody id='tbody_modal'></tbody>");
	if (div == 0) {
		let ll2 = ll.split(',');
		let lat = ll2[0].substr(7, 7);
		let lng = ll2[1].substr(6, 8);
		$('#faconcname_modal').replaceWith("<p id='faconcname_modal'>" + lat + ' / ' + lng + '</p>');
		setModalconcAll(lat, lng);
	} else {
		let ll2 = ll.split(',');
		let lat = ll2[0].substr(17, 7);
		let lng = ll2[1].substr(6, 8);
		$('#faconcname_modal').replaceWith("<p id='faconcname_modal'>" + lat + ' / ' + lng + '</p>');

		lat = parseFloat(lat);
		lng = parseFloat(lng);
		setModalconcAll(lat, lng);
	}
}

function modal_close() {
	document.querySelector('.background').className = 'background';
}

function getTime() {
	const time = new Date();
	const hour = time.getHours();
	const minutes = time.getMinutes();
	const seconds = time.getSeconds();
	//clock.innerHTML = hour +":" + minutes + ":"+seconds;
	$('.h1-clock').replaceWith(
		'<h1 class = h1-clock>' +
			`${hour < 10 ? `0${hour}` : hour}:${minutes < 10 ? `0${minutes}` : minutes}:${
				seconds < 10 ? `0${seconds}` : seconds
			}` +
			'</h1>'
	);
}

function initClock() {
	setInterval(getTime, 1000);
}

initClock();
