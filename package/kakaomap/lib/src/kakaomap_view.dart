import 'dart:convert';
//import 'dart:ffi';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kakaomap_webview/src/kakao_figure.dart';
import 'package:kakaomap_webview/src/kakaomap_type.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:mbtitravel/function_manager.dart';

import 'package:mbtitravel/data_frame/data_frame.dart';
import 'package:provider/provider.dart';


class KakaoMapView extends StatelessWidget {
  /// Map width. If width is wider than screen size, the map center can be changed
  final double width;

  /// Map height
  final double height;

  /// default zoom level : 3 (0 ~ 14)
  final int zoomLevel;

  /// center latitude
  final double lat;

  /// center longitude
  final double lng;

  /// Kakao map key javascript key
  final String kakaoMapKey;

  /// If it's true, zoomController will be enabled.
  final bool showZoomControl;

  /// If it's true, mapTypeController will be enabled. Normal map, Sky view are supported
  final bool showMapTypeControl;

  /// Location

  final bool OpenKakaoMap;

  /// Set marker image. If it's null, default marker will be showing
  final String markerImageURL;

  /// TRAFFIC, ROADVIEW, TERRAIN, USE_DISTRICT, BICYCLE are supported.
  /// If null, type is default
  final MapType? mapType;

  /// Set marker draggable. Default is false
  final bool draggableMarker;

  /// Overlay text. If null, it won't be enabled.
  /// It must not be used with [customOverlay]
  final String? overlayText;

  /// Overlay style. You can customize your own overlay style
  final String? customOverlayStyle;

  /// Overlay text with other features.
  /// It must not be used with [overlayText]
  final String? customOverlay;

  /// Marker tap event
  final void Function(JavascriptMessage)? onTapMarker;

  /// Zoom change event
  final void Function(JavascriptMessage)? zoomChanged;

  /// When user stop moving camera, this event will occur
  final void Function(JavascriptMessage)? cameraIdle;

  /// North East, South West lat, lang will be updated when the move event is occurred
  final void Function(JavascriptMessage)? boundaryUpdate;

  /// [KakaoFigure] is required [KakaoFigure.path] to make polygon.
  /// If null, it won't be enabled
  final KakaoFigure? polygon;

  /// [KakaoFigure] is required [KakaoFigure.path] to make polyline.
  /// If null, it won't be enabled
  final KakaoFigure? polyline;

  /// This is used to make your own features.
  /// Only map size and center position is set.
  /// And other optional features won't work.
  /// such as Zoom, MapType, markerImage, onTapMarker.
  final String? customScript;
  final String? viewAddMakers;

  /// When you want to use key for the widget to get some features.
  /// such as position, size, etc you can use this
  final GlobalKey? mapWidgetKey;

  /// You can use js code with controller.
  /// example)
  /// mapController.evaluateJavascript('map.setLevel(map.getLevel() + 1, {animate: true})');
  final void Function(WebViewController)? mapController;

  KakaoMapView(
      {required this.width,
      required this.height,
      required this.kakaoMapKey,
      required this.lat,
      required this.lng,
      this.zoomLevel = 3,
      this.overlayText,
      this.customOverlayStyle,
      this.customOverlay,
      this.polygon,
      this.polyline,
      this.showZoomControl = false,
      this.showMapTypeControl = false,
      this.onTapMarker,
      this.zoomChanged,
      this.cameraIdle,
      this.boundaryUpdate,
      this.markerImageURL = '',
      this.customScript,
      this.viewAddMakers,
      this.mapWidgetKey,
      this.draggableMarker = false,
      this.mapType,
      // 각 관광지 좌표 함수
      this.OpenKakaoMap = false,
      this.mapController});
// 사용자 정의 스크립트
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: mapWidgetKey,
      height: height,
      width: width,
      child: WebView(
        initialUrl: (customScript == null) ? _getHTML() : _customScriptHTML(),
        onWebViewCreated: mapController,
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: _getChannels(context),
        debuggingEnabled: true,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
          Factory(() => EagerGestureRecognizer()),
        ].toSet(),
      ),
    );
  }

  Set<JavascriptChannel>? _getChannels(BuildContext context) {
    final markerPositionsModel = Provider.of<MarkerPositionsModel>(context);

    Set<JavascriptChannel>? channels = {};
    if (OpenKakaoMap != false)
    {
      channels.add(JavascriptChannel(
          name: 'OpenKakaoMap', onMessageReceived: (JavascriptMessage message) async
          {
            List<Map<String, dynamic>> markerPositions = markerPositionsModel.markerPositions;
            if (message.message == 'OpenKakaoMapApp001')
            {
              await openKakaoMap(markerPositions, 1);
            }

            if (message.message == 'OpenKakaoMapApp002')
            {
              await openKakaoMap(markerPositions, 2);
            }

            if (message.message == 'OpenKakaoMapApp003')
            {
              await openKakaoMap(markerPositions, 3);
            }

            if (message.message == 'OpenKakaoMapApp004')
            {
              await openKakaoMap(markerPositions, 4);
            }

            if (message.message == 'OpenKakaoMapApp005')
            {
              await openKakaoMap(markerPositions, 5);
            }

            if (message.message == 'OpenKakaoMapApp006')
            {
              await openKakaoMap(markerPositions, 6);
            }

            if (message.message == 'OpenKakaoMapApp007')
            {
              await openKakaoMap(markerPositions, 7);
            }

            if (message.message == 'OpenKakaoMapApp008')
            {
              await openKakaoMap(markerPositions, 8);
            }

            if (message.message == 'OpenKakaoMapApp009')
            {
              await openKakaoMap(markerPositions, 9);
            }

            if (message.message == 'OpenKakaoMapApp010')
            {
              await openKakaoMap(markerPositions, 10);
            }
          }
      ));
    }

    if (onTapMarker != null) {
      channels.add(JavascriptChannel(
          name: 'onTapMarker', onMessageReceived: onTapMarker!));
    }

    if (zoomChanged != null) {
      channels.add(JavascriptChannel(
          name: 'zoomChanged', onMessageReceived: zoomChanged!));
    }

    if (cameraIdle != null) {
      channels.add(JavascriptChannel(
          name: 'cameraIdle', onMessageReceived: cameraIdle!));
    }

    if (boundaryUpdate != null) {
      channels.add(JavascriptChannel(
          name: 'boundaryUpdate', onMessageReceived: boundaryUpdate!));
    }

    if (channels.isEmpty) {
      return null;
    }

    return channels;
  }

  String _getHTML() {
    String markerImageOption = '';
    String overlayStyle = '';

    if (markerImageURL.isNotEmpty) {
      markerImageOption = 'image: markerImage';
    }

    if (overlayText != null) {
      if (customOverlayStyle == null) {
        overlayStyle = '''
<style>
  .label {margin-bottom: 96px;}
  .label * {display: inline-block;vertical-align: top;}
  .label .left {background: url("https://t1.daumcdn.net/localimg/localimages/07/2011/map/storeview/tip_l.png") no-repeat;display: inline-block;height: 24px;overflow: hidden;vertical-align: top;width: 7px;}
  .label .center {background: url(https://t1.daumcdn.net/localimg/localimages/07/2011/map/storeview/tip_bg.png) repeat-x;display: inline-block;height: 24px;font-size: 12px;line-height: 24px;}
  .label .right {background: url("https://t1.daumcdn.net/localimg/localimages/07/2011/map/storeview/tip_r.png") -1px 0  no-repeat;display: inline-block;height: 24px;overflow: hidden;width: 6px;}
</style>
      ''';
      } else {
        overlayStyle = customOverlayStyle ?? '';
      }
    } else {
      overlayStyle = customOverlayStyle ?? '';
    }

    return Uri.dataFromString('''
<html lang="ko">
<head>
  <meta name='viewport' content='width=device-width, initial-scale=1.0, user-scalable=yes\'>
  <title></title>
  <script>    
    /*관광지 호출*/
    function CallKakaoMap(id) 
    {
      if(id != null && id == 1)
      {
        if (window.OpenKakaoMap)
          window.OpenKakaoMap.postMessage('OpenKakaoMapApp001');
        else 
          console.error('id : 1 is not available.');
      }
      
      if(id != null && id == 2)
      {
        if (window.OpenKakaoMap)
          window.OpenKakaoMap.postMessage('OpenKakaoMapApp002');
        else 
          console.error('id : 2 is not available.');
      }
      
      if(id != null && id == 3)
      {
        if (window.OpenKakaoMap)
          window.OpenKakaoMap.postMessage('OpenKakaoMapApp003');
        else 
          console.error('id : 3 is not available.');
      }
      
      if(id != null && id == 4)
      {
        if (window.OpenKakaoMap)
          window.OpenKakaoMap.postMessage('OpenKakaoMapApp004');
        else 
          console.error('id : 4 is not available.');
      }
      
      if(id != null && id == 5)
      {
        if (window.OpenKakaoMap)
          window.OpenKakaoMap.postMessage('OpenKakaoMapApp005');
        else 
          console.error('id : 5 is not available.');
      }
      
      if(id != null && id == 6)
      {
        if (window.OpenKakaoMap)
          window.OpenKakaoMap.postMessage('OpenKakaoMapApp006');
        else 
          console.error('id : 6 is not available.');
      }
      
      if(id != null && id == 7)
      {
        if (window.OpenKakaoMap)
          window.OpenKakaoMap.postMessage('OpenKakaoMapApp007');
        else 
          console.error('id : 7 is not available.');
      }
      
      if(id != null && id == 8)
      {
        if (window.OpenKakaoMap)
          window.OpenKakaoMap.postMessage('OpenKakaoMapApp008');
        else 
          console.error('id : 8 is not available.');
      }
      
      if(id != null && id == 9)
      {
        if (window.OpenKakaoMap)
          window.OpenKakaoMap.postMessage('OpenKakaoMapApp009');
        else 
          console.error('id : 1 is not available.');
      }
      
      if(id != null && id == 10)
      {
        if (window.OpenKakaoMap)
          window.OpenKakaoMap.postMessage('OpenKakaoMapApp010');
        else 
          console.error('id : 10 is not available.');
      }                                                                      
    }
  </script>
  <script type="text/javascript" src='https://dapi.kakao.com/v2/maps/sdk.js?autoload=true&appkey=$kakaoMapKey'></script>
$overlayStyle
</head>
<body style="padding:0; margin:0;">
	<div id='map' style="width:100%;height:100%;min-width:${width}px;min-height:${height}px;"/>
	<script>
		const container = document.getElementById('map');
		
		const options = {
			center: new kakao.maps.LatLng($lat, $lng),
			level: $zoomLevel
		};

		const map = new kakao.maps.Map(container, options);
		
		let markerImage
		
		if(${markerImageURL.isNotEmpty}){
		  let imageSrc = '$markerImageURL'
		  let imageSize = new kakao.maps.Size(64, 69)
		  let imageOption = {offset: new kakao.maps.Point(27, 69)}
		  markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption)
		}
  /*
      마커 생성 부분(주석 처리 됨)
  */
    if(${viewAddMakers == null})
    {
      const markerPosition  = new kakao.maps.LatLng($lat, $lng);

      const marker = new kakao.maps.Marker({
      position: markerPosition,
      $markerImageOption
      });

      marker.setMap(map);

    }

    if(${viewAddMakers != null})
    {
      $viewAddMakers
    }

    if(${overlayText != null}){
      const content = '<div class ="label"><span class="left"></span><span class="center">$overlayText</span><span class="right"></span></div>';
  
      const overlayPosition = new kakao.maps.LatLng($lat, $lng);  
  
      const customOverlay = new kakao.maps.CustomOverlay({
          map: map,
          position: overlayPosition,
          content: content,
          yAnchor: 0.8
      });
    } else if(${customOverlay != null}){
      $customOverlay
    }
    
    if(${onTapMarker != null}){
      kakao.maps.event.addListener(marker, 'click', function(){
        onTapMarker.postMessage('marker is tapped');
      });
    }
		
		if(${zoomChanged != null}){
		  kakao.maps.event.addListener(map, 'zoom_changed', function() {        
        const level = map.getLevel();
        zoomChanged.postMessage(level.toString());
      });
		}
		
		if(${cameraIdle != null}){
		  kakao.maps.event.addListener(map, 'dragend', function() {        
        const latlng = map.getCenter();
        
        const idleLatLng = {
          lat: latlng.getLat(),
          lng: latlng.getLng()
        }
        
        cameraIdle.postMessage(JSON.stringify(idleLatLng));
      });
		}
		
		if(${boundaryUpdate != null}){
		  kakao.maps.event.addListener(map, 'bounds_changed', function() {  
        const bounds = map.getBounds();
    
        const neLatlng = bounds.getNorthEast();
        
        const swLatlng = bounds.getSouthWest();
        
        const boundary = {
          ne: {
            lat: neLatlng.getLat(),
            lng: neLatlng.getLng()
          },
          sw: {
            lat: swLatlng.getLat(),
            lng: swLatlng.getLng()
          }
        }
        
        boundaryUpdate.postMessage(JSON.stringify(boundary));
      });
		}
		
		if($showZoomControl){
		  const zoomControl = new kakao.maps.ZoomControl();
      map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
    }
    
    if($showMapTypeControl){
      const mapTypeControl = new kakao.maps.MapTypeControl();
      map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
    }
    
    if(${mapType != null}){
      const changeMapType = ${mapType?.getType};
      
      map.addOverlayMapTypeId(changeMapType);
    }
    
    marker.setDraggable($draggableMarker); 
    
    if(${polygon != null}){
      const polygon = new kakao.maps.Polygon({
	      map: map,
        path: [${polygon?.getPath}],
        strokeWeight: ${polygon?.strokeWeight},
        strokeColor: ${polygon?.getStrokeColor},
        strokeOpacity: ${polygon?.strokeColorOpacity},
        strokeStyle: '${polygon?.strokeStyle.name}',
        fillColor: ${polygon?.getPolygonColor},
        fillOpacity: ${polygon?.polygonColorOpacity} 
      });
    }
    
    if(${polyline != null}){
      const polyline = new kakao.maps.Polyline({
        map: map,
        path: [${polyline?.getPath}],
        strokeWeight: ${polyline?.strokeWeight},
        strokeColor: ${polyline?.getStrokeColor},
        strokeOpacity: ${polyline?.strokeColorOpacity},
        strokeStyle: '${polyline?.strokeStyle.name}'
      });
    }
	</script>
</body>
</html>
    ''', mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();
  }

// 커스텀 JavaScripts
  String _customScriptHTML() {
    return Uri.dataFromString('''
<html>
<head>
  <meta name='viewport' content='width=device-width, initial-scale=1.0, user-scalable=yes\'>
  <script type="text/javascript" src='https://dapi.kakao.com/v2/maps/sdk.js?autoload=true&appkey=$kakaoMapKey'></script>
</head>
<body style="padding:0; margin:0;">
	<div id='map' style="width:100%;height:100%;min-width:${width}px;min-height:${height}px;"></div>
	<script>
		const container = document.getElementById('map');
				
		const options = {
			center: new kakao.maps.LatLng($lat, $lng),
			level: $zoomLevel
		};

		const map = new kakao.maps.Map(container, options);
		$customScript
	</script>
</body>
</html>
    ''', mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();
  }
}
