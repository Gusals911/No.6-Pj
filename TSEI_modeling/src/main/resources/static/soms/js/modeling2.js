var map;
var rectangle = [];
var markers = [];
var loadingAnimation;
var selectDate;
var selectHours;
var altitude;
var company = 0;
var placesData;
var affectedPlaces = [];
document.addEventListener('DOMContentLoaded', function () {
	initMap();
	setTimeout(function () {
		init(); // 초기 필요한 데이터 로드
	}, 1000);
});

function button_function4() {
	const btn = document.getElementById('item4');
	btn.classList.add('clicked');
}

// 최초 실행
const init = () => {
	modelingDate_ajax(); // 모델링 데이터가 존재하는 날짜 요청
	placesData = get_placeData();
	//markerCreate();
	create_company();
	modeling_fn();
	getWeather_Realtime();
	//modeling_ajax($("#selectDate").val(), $("#selectTime").val());// 모델링 데이터 생성
};

// 구글맵 생성
function initMap() {
	var position = {
		lat: 35.456759,
		lng: 129.327684,
	};
	var zoom = 15;
	var mapLocation = new google.maps.LatLng(position); // 지도에서 가운데로 위치할 위도와 경도
	var options = {
		center: mapLocation,
		zoom: zoom,
		mapId: '4504f8b37365c3d0',
		disableDefaultUI: true, //기본 UI 사용 여부
		disableDoubleClickZoom: true, //더블클릭 중심으로 확대 사용 여부
		draggable: true, //지도 드래그 이동 사용 여부
		keyboardShortcuts: false, //키보드 단축키 사용 여부
		maxZoom: 16, //최대 줌
		minZoom: 10, //최소 줌
		gestureHandling: 'greedy', //ctrl 없이 마우스 휠로 줌 가능
		zoomControl: false, // 지도의 확대/축소 수준을 변경하는 데 사용되는 "+"와 "-" 버튼을 표시합니다. 기본적으로 이 컨트롤은 지도의 오른쪽 아래 모서리에 나타납니다.
		mapTypeControl: true, // 드롭다운이나 가로 버튼 막대 스타일로 제공되며, 사용자가 지도 유형(ROADMAP, SATELLITE, HYBRID 또는 TERRAIN)을 선택할 수 있습니다. 이 컨트롤은 기본적으로 지도의 왼쪽 위 모서리에 나타납니다.
		mapTypeControlOptions: {
			style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
			position: google.maps.ControlPosition.TOP_RIGHT,
		},
		scaleControl: false, // 지도로 드래그해서 스트리트 뷰를 활성화할 수 있는 펙맨 아이콘이 있습니다. 기본적으로 이 컨트롤은 지도의 오른쪽 아래 근처에 나타납니다.
		streetViewControl: false, // 경사진 이미지가 포함된 지도에 틸트와 회전 옵션 조합을 제공합니다. 기본적으로 이 컨트롤은 지도의 오른쪽 아래 근처에 나타납니다. 자세한 내용은 45° 이미지를 참조하세요.
		rotateControl: true, // 지도 배율 요소를 표시합니다. 이 컨트롤은 기본적으로 비활성화되어 있습니다.
		mapTypeId: google.maps.MapTypeId.SATELLITE,
		/* 기본 로드맵 보기를 표시합니다. */
	};
	map = new google.maps.Map(document.getElementById('newMap'), options);

	google.maps.event.addListener(map, 'click', function (event) {
		placeMarker(event.latLng);
		modal_close();
		modal_show(event.latLng, 0);
	});

	//gridCreate(); //격자좌표생성
	//dashCreate2();
}

var marker = null;

function placeMarker(location) {
	if (marker) {
		marker.setMap(null);
	}
	marker = new google.maps.Marker({
		position: location,
		map: map,
	});
}

function markerCreate() {
	if (markers.length > 0) {
		for (let i = 0; i < markers.length; i++) {
			markers[i].map = null;
		}
	}

	for (let i = 0; i < placesData.length; i++) {
		var place = { lat: placesData[i]['lat'], lng: placesData[i]['lon'] };
		markers[i] = new google.maps.marker.AdvancedMarkerView({
			map,
			content: buildContent(placesData[i]),
			position: place,
			title: placesData[i]['name'],
		});
		var content =
			'<div id="iw-container">' +
			'<table class="marker-table" border="1" >' +
			'<th>업종</th>' +
			'<th>악취 종류</th>' +
			'<th>방지시설명</th>' +
			'<th>배출구명</th>' +
			'<th>배출량(㎥/분)</th>' +
			'<tr>' +
			'<td>석유 정제품 제조업</td>' +
			'<td>생선비린내</td>' +
			'<td>스크러버</td>' +
			'<td>배출구-1</td>' +
			'<td>500</td>' +
			'</tr>' +
			'</table>' +
			'</div>';

		var infowindow = new google.maps.InfoWindow({
			content: content,
			pixelOffset: new google.maps.Size(0, 80),
		});
		google.maps.event.addListener(markers[i], 'click', function () {
			infowindow.open(map, markers[i]);
		});
	}
}

function buildContent(place) {
	const content = document.createElement('div');
	content.classList.add('office-tag');
	if (place.poi == true) {
		content.style.backgroundColor = 'blue';
		content.innerHTML = `
				<div class="icon">
					<i aria-hidden="true" class="bi bi-star-fill"></i>
					<span>&nbsp;${place.name}</span>
				</div>
				`;
	} else {
		console.log('alength: ', affectedPlaces.length);
		for (var i = 0; i < affectedPlaces.length; i++) {
			console.log(place.p_index, ' / ', affectedPlaces[i]);
			if (place.p_index == affectedPlaces[i]) {
				content.style.backgroundColor = 'red';
			}
		}
		content.innerHTML = `
				<div class="icon">
					<i aria-hidden="true" class="bi bi-geo-alt-fill"></i>
					<span>&nbsp;${place.name}</span>
				</div>
				`;
	}

	return content;
}

// 격자 칸 악취 농도 값에 비례하여 색칠
function conc_color(result) {
	if (rectangle[0]) {
		for (var i = 0; i < rectangle.length; i++) {
			rectangle[i].setMap(null);
		}
	}
	var i = 0;
	for (idx of result) {
		rectangle[i] = new google.maps.Rectangle({
			strokeColor: setColor(idx.conc),
			strokeOpacity: 0,
			strokeWeight: 1,
			fillColor: setColor(idx.conc),
			fillOpacity: 0.3,
			clickable: true,
			map: map,
			bounds: {
				north: idx.lat + 0.00045,
				south: idx.lat - 0.00045,
				east: idx.lon + 0.00055,
				west: idx.lon - 0.00055,
			},
		});
		rectangle[i++].addListener('click', (e) => {
			animation_show();
			setTimeout(() => {
				modal_close();
				modal_show(e, 1);
				placeMarker(e.latLng);
				animation_hide();
			}, 100);
		});
	}
}

function setColor(param) {
	let color = 0;
	if (param >= 0 && param < 3) {
		color = '#FBEFEF';
	} else if (param >= 3 && param < 10) {
		color = '#F5A9A9';
	} else if (param >= 10 && param < 30) {
		color = '#FE2E2E';
	} else if (param >= 30 && param < 100) {
		color = '#B40404';
	} else {
		color = '#610B0B';
	}
	return color;
}

// 날짜 설정
const set_date = () => {
	let today = new Date();
	let day = today.getDate();
	let month = today.getMonth() + 1;

	day = ('0' + day).slice(-2);
	month = ('0' + month).slice(-2);

//	selectDate = today.getFullYear() + '-' + month + '-' + day;
	selectHours = today.getHours();

	if (selectHours < 10) {
		selectHours = '0' + selectHours;
	}
//	$('#selectDate').val(selectDate);
	$('#selectDate option:first-child').attr('selected', true);
	$('#selectTime').val(selectHours);
};

// 날짜 셀렉트 옵션 생성
const create_date = (data) => {
	let option = '';
	for (idx of data) {
		option += '<option value=' + idx + '>' + idx + '</option>';
	}
	$('#selectDate').append(option);
};

const create_company = () => {
	let option = '<option value=0 selected>전체 사업장</option>';
	for (idx of placesData) {
		if (idx.poi != 1) {
			option += '<option value=' + idx.p_index + '>' + idx['name'] + '</option>';
		}
	}
	$('#selectCompany').innerHTML = '';
	$('#selectCompany').append(option);
};

const animation_show = () => {
	const loadingAnimation = document.getElementById('loading-animation');
	loadingAnimation.style.display = 'block';
};

const animation_hide = () => {
	const loadingAnimation = document.getElementById('loading-animation');
	loadingAnimation.style.display = 'none';
};
