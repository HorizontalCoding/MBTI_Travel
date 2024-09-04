// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:kakaomap_webview/kakaomap_webview.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter/webview_flutter.dart';

/*
================================================================================
View_Maker(여러 개 마커 표시 하기) + 커스텀 오버레이 표시
================================================================================
 */

// import 'package:http/http.dart';

String VIEW_MAKER_SCRIPT(List<Map<String, dynamic>> _markerPositions)
{
  StringBuffer VIEW_MAKER_SCRIPT = StringBuffer();

  for (var position in _markerPositions)
  {
    VIEW_MAKER_SCRIPT.writeln('''
        if(${position['id']} == 1)
        {
          var imageSrc = 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Maker/number-1.png';

          var imageSize = new kakao.maps.Size(64, 64);

          var imageOption = {offset: new kakao.maps.Point(32, 69)};

          var markerImg = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
          var markerPosition = new kakao.maps.LatLng(${position['lat']}, ${position['lng']});
        
          var marker = new kakao.maps.Marker({
                position: markerPosition,
                image: markerImg });
        
          marker.setMap(map);
        }
        
        if(${position['id']} == 2)
        {
          var imageSrc = 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Maker/number-2.png';

          var imageSize = new kakao.maps.Size(64, 64);

          var imageOption = {offset: new kakao.maps.Point(32, 69)};

          var markerImg = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
          var markerPosition = new kakao.maps.LatLng(${position['lat']}, ${position['lng']});
        
          var marker = new kakao.maps.Marker({
                position: markerPosition,
                image: markerImg });
        
          marker.setMap(map);
        }
        
        if(${position['id']} == 3)
        {
          var imageSrc = 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Maker/number-3.png';

          var imageSize = new kakao.maps.Size(64, 64);

          var imageOption = {offset: new kakao.maps.Point(32, 69)};

          var markerImg = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
          var markerPosition = new kakao.maps.LatLng(${position['lat']}, ${position['lng']});
        
          var marker = new kakao.maps.Marker({
                position: markerPosition,
                image: markerImg });
        
          marker.setMap(map);
        }
        
        if(${position['id']} == 4)
        {
          var imageSrc = 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Maker/number-4.png';

          var imageSize = new kakao.maps.Size(64, 64);

          var imageOption = {offset: new kakao.maps.Point(32, 69)};

          var markerImg = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
          var markerPosition = new kakao.maps.LatLng(${position['lat']}, ${position['lng']});
        
          var marker = new kakao.maps.Marker({
                position: markerPosition,
                image: markerImg });
        
          marker.setMap(map);
        }
        
        if(${position['id']} == 5)
        {
          var imageSrc = 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Maker/number-5.png';

          var imageSize = new kakao.maps.Size(64, 64);

          var imageOption = {offset: new kakao.maps.Point(32, 69)};

          var markerImg = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
          var markerPosition = new kakao.maps.LatLng(${position['lat']}, ${position['lng']});
        
          var marker = new kakao.maps.Marker({
                position: markerPosition,
                image: markerImg });
        
          marker.setMap(map);
        }
        
        if(${position['id']} == 6)
        {
          var imageSrc = 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Maker/number-6.png';

          var imageSize = new kakao.maps.Size(64, 64);

          var imageOption = {offset: new kakao.maps.Point(32, 69)};

          var markerImg = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
          var markerPosition = new kakao.maps.LatLng(${position['lat']}, ${position['lng']});
        
          var marker = new kakao.maps.Marker({
                position: markerPosition,
                image: markerImg });
        
          marker.setMap(map);
        }
        
        if(${position['id']} == 7)
        {
          var imageSrc = 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Maker/number-7.png';

          var imageSize = new kakao.maps.Size(64, 64);

          var imageOption = {offset: new kakao.maps.Point(32, 69)};

          var markerImg = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
          var markerPosition = new kakao.maps.LatLng(${position['lat']}, ${position['lng']});
        
          var marker = new kakao.maps.Marker({
                position: markerPosition,
                image: markerImg });
        
          marker.setMap(map);
        }
        
        if(${position['id']} == 1)
        {
          var noContent01 = '<div class="customoverlay">' + 
                        '<a href="javascript:void(0);" onclick="CallKakaoMap(${position['id']})" target="_self">' + 
                        '<span class="title">${position['name']}</span>' + 
                        '</a>' + 
                        '</div>';
                        
          var overlayPosition = new kakao.maps.LatLng(${position['lat']}, ${position['lng']});

          var customOverlay = new kakao.maps.CustomOverlay({
                map: map,
                position: overlayPosition,
                content: noContent01,
                yAnchor: 1});
        }
        
        if(${position['id']} == 2)
        {
          var noContent01 = '<div class="customoverlay">' + 
                        '<a href="javascript:void(0);" onclick="CallKakaoMap(${position['id']})" target="_self">' + 
                        '<span class="title">${position['name']}</span>' + 
                        '</a>' + 
                        '</div>';
                        
          var overlayPosition = new kakao.maps.LatLng(${position['lat']}, ${position['lng']});

          var customOverlay = new kakao.maps.CustomOverlay({
                map: map,
                position: overlayPosition,
                content: noContent01,
                yAnchor: 1});
        }
        
        if(${position['id']} == 3)
        {
          var noContent01 = '<div class="customoverlay">' + 
                        '<a href="javascript:void(0);" onclick="CallKakaoMap(${position['id']})" target="_self">' + 
                        '<span class="title">${position['name']}</span>' + 
                        '</a>' + 
                        '</div>';
                        
          var overlayPosition = new kakao.maps.LatLng(${position['lat']}, ${position['lng']});

          var customOverlay = new kakao.maps.CustomOverlay({
                map: map,
                position: overlayPosition,
                content: noContent01,
                yAnchor: 1});
        }
        
        if(${position['id']} == 4)
        {
          var noContent01 = '<div class="customoverlay">' + 
                        '<a href="javascript:void(0);" onclick="CallKakaoMap(${position['id']})" target="_self">' + 
                        '<span class="title">${position['name']}</span>' + 
                        '</a>' + 
                        '</div>';
                        
          var overlayPosition = new kakao.maps.LatLng(${position['lat']}, ${position['lng']});

          var customOverlay = new kakao.maps.CustomOverlay({
                map: map,
                position: overlayPosition,
                content: noContent01,
                yAnchor: 1});
        }
        
        if(${position['id']} == 5)
        {
          var noContent01 = '<div class="customoverlay">' + 
                        '<a href="javascript:void(0);" onclick="CallKakaoMap(${position['id']})" target="_self">' + 
                        '<span class="title">${position['name']}</span>' + 
                        '</a>' + 
                        '</div>';
                        
          var overlayPosition = new kakao.maps.LatLng(${position['lat']}, ${position['lng']});

          var customOverlay = new kakao.maps.CustomOverlay({
                map: map,
                position: overlayPosition,
                content: noContent01,
                yAnchor: 1});
        }
        
        if(${position['id']} == 6)
        {
          var noContent01 = '<div class="customoverlay">' + 
                        '<a href="javascript:void(0);" onclick="CallKakaoMap(${position['id']})" target="_self">' + 
                        '<span class="title">${position['name']}</span>' + 
                        '</a>' + 
                        '</div>';
                        
          var overlayPosition = new kakao.maps.LatLng(${position['lat']}, ${position['lng']});

          var customOverlay = new kakao.maps.CustomOverlay({
                map: map,
                position: overlayPosition,
                content: noContent01,
                yAnchor: 1});
        }
        
        if(${position['id']} == 7)
        {
          var noContent01 = '<div class="customoverlay">' + 
                        '<a href="javascript:void(0);" onclick="CallKakaoMap(${position['id']})" target="_self">' + 
                        '<span class="title">${position['name']}</span>' + 
                        '</a>' + 
                        '</div>';
                        
          var overlayPosition = new kakao.maps.LatLng(${position['lat']}, ${position['lng']});

          var customOverlay = new kakao.maps.CustomOverlay({
                map: map,
                position: overlayPosition,
                content: noContent01,
                yAnchor: 1});
        }

      ''');
  }
  return VIEW_MAKER_SCRIPT.toString();
}
/*
================================================================================
커스텀 오버레이 표시 스타일 설정
================================================================================
 */

String CUSTOM_OVERLAY_STYLE_SCRIPT() {
  StringBuffer CUSTOM_OVERLAY_STYLE_SCRIPT = StringBuffer();
  CUSTOM_OVERLAY_STYLE_SCRIPT.writeln('''
  <style>
  .customoverlay {position:relative;bottom:85px;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd;float:left;}
  .customoverlay:nth-of-type(n) {border:0; box-shadow:0px 1px 2px #888;}
  .customoverlay a {display:block;text-decoration:none;color:#000;text-align:center;border-radius:6px;font-size:14px;font-weight:bold;overflow:hidden;background: #d95050;background: #d95050 url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/arrow_white.png) no-repeat right 14px center;}
  .customoverlay .title {display:block;text-align:center;background:#fff;margin-right:35px;padding:10px 15px;font-size:14px;font-weight:bold;}
  .customoverlay:after {content:'';position:absolute;margin-left:-12px;left:50%;bottom:-12px;width:22px;height:12px;background:url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png')}
</style>
  ''');
  return CUSTOM_OVERLAY_STYLE_SCRIPT.toString();
}
