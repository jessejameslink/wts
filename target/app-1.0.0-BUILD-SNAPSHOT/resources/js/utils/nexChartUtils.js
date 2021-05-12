(function(window, undefined) {
  var nexChartUtils = {
    /**
     * 차트 디폴트 옵션
     */
    hichartOptions: {
     colors: [
        '#EF2D00', '#0071C8', '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655',
			'#FFF263', '#6AF9C4', 'rgb(80,80,80)', '#FF62B8', '#7DD5FF', '#F98EC1', 'rgb(84,164,5)', 
			'rgb(24,134,216)', 'rgb(1,2,200)', 'rgb(126,27,89)'
      ],
      chart: {
        alignTicks: false,
        animation: false,
        backgroundColor: null,
        borderWidth: 0, // 차트 제일 외각선
        borderColor: '', // 차트 제일 외각선 색상
        borderRadius: 0, // 차트 Border 외각선 굴림 정도
        plotBackgroundColor: null,
        plotShadow: false, // 차트 영역 그림자
        plotBorderColor: 'rgb(176,176,176)',
        plotBorderWidth: 0,
        spacingTop: 20,
        spacingRight: 10,
        spacingBottom: 0,
        spacingLeft: 10,
        shadow: false
      },
      lang: { // 언어설정:정인식(샘플입니다. 필요시 수정바람)
        rangeSelectorZoom: '표시범위',
        resetZoom: '표시기간을리셋',
        resetZoomTitle: '표시기간을리셋',
        rangeSelectorFrom: '표시기간',
        rangeSelectorTo: '~',
        printButtonTitle: '차트를인쇄',
        exportButtonTitle: '이미지로 다운로드',
        downloadJPEG: 'JPEG이미지로 다운로드',
        downloadPDF: 'PDF문서로 다운로드',
        downloadPNG: 'PNG이미지로 다운로드',
        downloadSVG: 'SVG 다운로드',
        months: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        weekdays: ['일', '월', '화', '수', '목', '금', '토'],
        numericSymbols: null // 1000을 1k로 표시하지 않는다.
      },
      title: {
        style: {
          color: 'black',
          font: 'bold 16px "돋음",Dotum,"굴림",Gulim,"Trebuchet MS", Verdana, sans-serif'
        }
      },
      subtitle: {
        style: {
          color: 'black',
          font: 'bold 12px "돋음",Dotum,"굴림",Gulim,"Trebuchet MS", Verdana, sans-serif'
        }
      },
      navigator: {
        enabled: false,
        maskInside: false,
        outlineColor: 'rgb(176,176,176)',
        maskFill: 'rgba(30, 34, 42, 0.2)',
        series: {
          type: 'area',
          // color: '#2E435E',
          fillOpacity: 0.2
        },
        yAxis: {
          tickWidth: 0,
          tickLength: 0,
          minorTickLength: 0,
          minorTickWidth: 0
        }
      },
      rangeSelector: {
        enabled: false
      },
      scrollbar: {
        enabled: false
      },
      xAxis: {
        //gridLineWidth: 1,
        lineColor: 'rgb(176,176,176)',
        tickColor: 'rgb(176,176,176)',
        labels: {
          staggerLines: 1,
          style: {
            color: 'black',
            font: '11px "맑은 고딕",Dotum,"굴  림",Gulim,AppleGothic,Arial,Helvetica,sans-serif'
          }
        },
        title: {
          style: {
            color: 'black',
            fontWeight: 'bold',
            fontSize: '12px',
            fontFamily: '"맑은 고딕","Malgun Gothic","굴림",Gulim,"돋음",Dotum,AppleGothic,Arial,Helvetica,sans-serif'
          }
        },
        dateTimeLabelFormats: {
          millisecond: '%H:%M:%S',
          second: '%H:%M:%S',
          minute: '%H:%M',
          hour: '%H:00',
          day: '%m/%d',
          week: '%m/%d',
          month: '%Y/%m',
          year: '%Y'
        },
        gridLineDashStyle: 'Solid', //y축 그리드 대쉬 스타일 'Solid','ShortDash','ShortDot','ShortDashDot','ShortDashDotDot','Dot','Dash','LongDash','DashDot','LongDashDot','LongDashDotDot'
        gridLineColor: 'rgb(176,176,176)',
        minorGridLineWidth: 0,
        minorTickLength: 5,
        minorTickWidth: 1
      },
      yAxis: {
        alternateGridColor: null, //y축 대쉬보드 백라운드 컬러 (토글형) '#000000'
        lineColor: 'rgb(224,224,224)',
        lineWidth: 1, //라인두깨
        tickWidth: 1, //
        tickColor: 'rgb(176,176,176)',
        minorGridLineWidth: 0,
        minorTickLength: 5, //틱 사이의 눈금갯수
        minorTickInterval: 'auto',
        minorTickWidth: 1,
        minorTickColor: 'rgb(176,176,176)',
        gridLineDashStyle: 'Solid', //y축 그리드 대쉬 스타일 'Solid','ShortDash','ShortDot','ShortDashDot','ShortDashDotDot','Dot','Dash','LongDash','DashDot','LongDashDot','LongDashDotDot'
        gridLineColor: 'rgb(224,224,224)',
        //gridLineWidth: 0,  - y축 그리드 라인 두께
        labels: {
          style: {
            color: 'black',
            font: '11px "맑은 고딕",Dotum,"굴림",Gulim,AppleGothic,Arial,Helvetica,sans-serif'
          },
          formatter: function() {
            return this.value; //눈금의 값 그대로 노출
          }
        },
        title: {
          text: null
        }
      },
      plotOptions: {
        candlestick: { //캔들차트 옵션 설정 (해당 Type 차트에만 적용시)
          color: '#0071C8',
          upColor: '#EF2D00',
          upLineColor: '#EF2D00',
          lineColor: "#0071C8",
          lineWidth: 1, //캔들차트 박스 라인
          eqColor: "black", //캔들차트 시가와 종가가 같은경우 색상.
          tooltip: {
            pointFormat:
            '<tr><td>Open: </td>'
            + '<td style="text-align:right; padding-left:10px">{point.open}</td></tr>'
            + '<tr><td>High: </td>'
            + '<td style="text-align:right; padding-left:10px">{point.high}</td></tr>'
            + '<tr><td>Low: </td>'
            + '<td style="text-align:right; padding-left:10px">{point.low}</td></tr>'
            + '<tr><td>Close: </td>'
            + '<td style="text-align:right; padding-left:10px">{point.close}</td></tr>'
          }
        },
        arearange: { //Area range 차트 옵션 설정 (해당 Type 차트에만 적용시
          tooltip: {
            pointFormat: '<tr><td style="color:{series.color}">{series.name}: </td>' + '<td style="text-align:right; padding-left:10px">{point.high}</td></tr>' //{point.low} - {point.high}
          }
        },
        columnrange: { //column range 차트 옵션 설정 (해당 Type 차트에만 적용시
          tooltip: {
            pointFormat: ''
              //                   '<tr><td style="color:{series.color}">{series.name}: </td>'
              //                   + '<td style="text-align:right; padding-left:10px">{point.low}</td></tr>'  //{point.low} - {point.high}
          }
        },
        line: {
          lineWidth: 1
        },
        series: {
          marker: {
            enabled: false
          },
          animation: false,
          borderWidth: 0
        },
        spline: {
          lineWidth: 1,
          states: {
            hover: {
              lineWidth: 2
            }
          },
          marker: {
            enabled: false
          }
          //pointInterval: 3600000, // one hour
          //pointStart: Date.UTC(timeCut[0], timeCut[1], timeCut[2], 09, 0, 0)
        }
      },
      legend: { //series 라벨(좌측상단에 고정..)
        enabled: true,
        align: 'left',
        verticalAlign: 'top',
        backgroundColor: '',
        borderColor: '',
        borderWidth: 0,
        borderRadius: 0,
        x: 40, //X위치
        y: 5, //Y위치
        floating: true, //그래프 위에 플로팅 여부
        itemStyle: {
          //font: '9pt Trebuchet MS, Verdana, sans-serif',
          color: 'black',
          //fontSize: '11px'
          font: '11px "맑은 고딕",Dotum,"굴림",Gulim,AppleGothic,Arial,Helvetica,sans-serif'
        },
        itemHoverStyle: {
          color: 'black'
        },
        itemHiddenStyle: {
          color: 'rgb(176,176,176)'
        }
      },
      credits: {
        enabled: false
      },
      labels: {
        style: {
          color: 'black'
        }
      },
      tooltip: {
        animation: false,
        backgroundColor: 'rgba(255,255,255,0.5)',
        borderWidth: 1,
        borderRadius: 0,
        borderColor: 'black',
        shadow: false,
        useHTML: true,
        style: {
			padding: 6
        },
        valueDecimals: 0,
		xDateFormat: "%Y/%m/%d",
        headerFormat: '<table style="min-width:125px; max-width:210px; color:black; font-family:Malgun Gothic; font-size:12px;">'
                    + '<colgroup><col style="width:25%"><col style="width:60%"></colgroup><tr><td>Date: </td><td style="color:black">{point.key}</td></tr>',
        pointFormat: '<tr><td style="color: {series.color}">{series.name}: </td>'
                    + '<td style="text-align: right; padding-left:10px">{point.y}</td></tr>',
        //pointFormat: '<span style="color:{series.color}">{series.name}</span>: {point.y}<br/>',
        footerFormat: '</table>',
        positioner: function(boxWidth, boxHeight, point) {
          //툴팁을 마우스 포인터를 따라다니도록 한다.
          return {
            x: point.plotX + this.chart.plotLeft,
            y: point.plotY + this.chart.plotTop
          };
        }
      }
    },

    /**
     * desc : 시간, 혹은 분 단위 NUM만큼 더하기
     * date : 2015.07.24
     * author : 김행선
     * @param type : 'HOURS', 'MINUTE'
     * @param date : 현재 DATE('2015051401', '201505140101')
     * @param num : 더할 시간 혹은 분
     * @return newDate
     */
    getAddTime: function(type, date, num) {
      var newDate = null;

      if (type == 'HOURS') {
        if (date.length < 10) {
          return null;
        }
        var year = date.substring(0, 4);
        var month = (Number(date.substring(4, 6)) - 1) + "";
        var day = date.substring(6, 8);
        var hours = date.substring(8, 10);
        var oldDate = new Date(year, month, day, hours);

        oldDate.setHours(oldDate.getHours() + num);
        newDate = oldDate.getFullYear() + '';
        newDate = newDate + nexUtils.addZero2(Number(oldDate.getMonth()) + 1, 2);
        newDate = newDate + nexUtils.addZero2(oldDate.getDate(), 2);
        newDate = newDate + nexUtils.addZero2(oldDate.getHours(), 2);

      } else if (type == 'MINUTE') {
        if (date.length < 12) {
          return null;
        }

        var year = date.substring(0, 4);
        var month = (Number(date.substring(4, 6)) - 1) + "";
        var day = date.substring(6, 8);
        var hours = date.substring(8, 10);
        var minute = date.substring(10, 12);
        var oldDate = new Date(year, month, day, hours, minute);

        oldDate.setMinutes(oldDate.getMinutes() + num);
        newDate = oldDate.getFullYear() + '';
        newDate = newDate + nexUtils.addZero2(Number(oldDate.getMonth()) + 1, 2);
        newDate = newDate + nexUtils.addZero2(oldDate.getDate(), 2);
        newDate = newDate + nexUtils.addZero2(oldDate.getHours(), 2);
        newDate = newDate + nexUtils.addZero2(oldDate.getMinutes(), 2);
      }

      return newDate;
    },

    /**
     * desc : 최고가 구하기
     * date : 2015.07.24
     * author : 김행선
     * @param index : 시작위치
     * @param len : 길이
     * @param data : 데이터
     * @return max
     */
    getHighMax: function(index, len, data) {
      var max = 0;
      if (len != 0) {
        for (var count = 0, mIndex = index + 1 - len; count < len; count++, mIndex++) {
          if (data[mIndex][2] != null && max < data[mIndex][2]) {
            max = data[mIndex][2];
          }
        }
      } else {
        max = data[mIndex][2];
      }

      return max;
    },

    /**
     * desc : 최저가 구하기
     * date : 2015.07.24
     * author : 김행선
     * @param index : 시작위치
     * @param len : 길이
     * @param data : 데이터
     * @return max
     */
    getLowMin: function(index, len, data) {
      var min = 1000000000;
      if (len != 0) {
        for (var count = 0, mIndex = index + 1 - len; count < len; count++, mIndex++) {
          if (data[mIndex][3] != null && min > data[mIndex][3]) {
            min = data[mIndex][3];
          }
        }
      } else {
        min = data[mIndex][3];
      }

      return min;
    },

    /**
     * desc : 툴팁의 헤더 날짜 포맷.
     * date : 2015.07.24
     * author : 김행선
     * @param monthSect : 주기
     * @return
     */
    getHederTimeFormat: function(monthSect) {
      switch (monthSect) {
        case '0':
          return "%Y/%m/%d, %H:%M:%S";
        case '1':
          return "%Y/%m/%d, %H:%M";
        case '2':
        case '3':
          return "%Y/%m/%d";
        case '4':
          return "%Y/%m";
        case '5':
          return "%Y/%m/%d, %H:00";
        default:
          return "%Y/%m/%d";
      }
    },
    
    chartHoga: function($selector, data, width, height) {
    	var rtnChart = {};
    	
    	var ohlc = [],
        volume = [],
        bDay5 = [],
        bDay10 = [];
    	
    	rtnChart['chartData'] = [];
    	
        var chartWidth = 116;
        var chartHeight = 170;
        var candleHeight = 170 * 0.6;
        var volumeHeight = 170 * 0.4;
        
        
        if(typeof width != 'undefined' && width != null && width != '') {
        	chartWidth = width;
    	}
    	
    	if(typeof height != 'undefined' && height != null && height != '') {
    		volumeHeight = height * 0.6;
        	candleHeight = height * 0.4;
    		chartHeight = height;
    	}
        
        for (var i = 0; i < data.length; i++) {            
            rtnChart['chartData'].unshift([
               Number(data[i][0]), // the date
               Number(data[i][1]), // open
               Number(data[i][2]), // high
               Number(data[i][3]), // low
               Number(data[i][4]), // close
               Number(data[i][5]) // volume
            ]);
            
            if(i <= 9) {
    	        //캔들차트
    	        ohlc.unshift([
    	            Number(data[i][0]), // the date
    	            Number(data[i][1]), // open
    	            Number(data[i][2]), // high
    	            Number(data[i][3]), // low
    	            Number(data[i][4]) // close
    	        ]);
    	
    	        //막대차트
    	        var col = "";
    	        if (Number(data[i][1]) > Number(data[i][4])){ 
    	            col = "#0071C8"; //종가하락
    	        } else if (Number(data[i][1]) == Number(data[i][4])){
    	            col = "black"; //변동없음
    	        } else {
    	            col = "#EF2D00"; //종가상승
    	        }
    	
    	        volume.unshift({
    	            x:Number(data[i][0]),
    	            y:Number(data[i][5]),
    	            color: col
    	        });
    	
    	        var dateSum5 = new Number();
    	        var dateSum10 = new Number();
    	
    	        // 5일전 종가 평균
    	        if ((i+5) < data.length) {
    	            for (var c = 0; c < 5; c++) {
    	                dateSum5 += Number(data[i+c][4]);
    	            }
    	            bDayVal = dateSum5 / 5;
    	            bDay5.unshift([Number(data[i][0]),Number(dateSum5 / 5)]);
    	        } else {
    	            bDay5.unshift([Number(data[i][0]),null]);
    	        }
    	
    	        // 20일전 종가 평균
    	        if ((i+10) < data.length) {
    	            for(var c = 0; c < 10; c++) {
    	                dateSum10 += Number(data[i+c][4]);
    	            }
    	            bDayVal = dateSum10 / 10;
    	            bDay10.unshift([Number(data[i][0]),Number(dateSum10 / 10)]);
    	        } else {
    	            bDay10.unshift([Number(data[i][0]),null]);
    	        }
            }
            
            if(i==9) {
            	break;
            }
        }
        rtnChart['currDate'] = Number(data[0][0]);
		rtnChart['chartData'].sort();
        rtnChart['chart'] = new Highcharts.StockChart({ 
            chart:{
            	renderTo: $selector[0],
                borderWidth: 0,
    			width: chartWidth,
                height: chartHeight,
                margin: [0,0,0,0],
                spacing: [0,0,0,0],
                zoomType:null,
                panning: false
            },
            navigator:{
                enabled: false
            },
            scrollbar:{
                enabled: false
            },
            rangeSelector: {
                enabled: false
            },
            credits: {
                enabled: false
            },
            legend: {
                enabled: false,
            },
            xAxis: {
                lineWidth: 0,
                tickWidth: 0,
                gridLineWidth: 0,
                labels: {
                    enabled: false
                },
                minorTickLength: 0,
                tickPixelInterval: 0,
				tickInterval : null
            },
            yAxis: [{
                lineWidth: 0,
                tickWidth: 0,
                gridLineWidth: 0,
                minorTickLength: 0,
                minorTickWidth: 0,
                labels: {
                    enabled: false
                },
                top: 0,
                height: candleHeight
            }, {
                offset: 0,
                lineWidth: 0,
                tickWidth: 0,
                gridLineWidth: 0,
                minorTickLength: 0,
                minorTickWidth: 0,
                labels: {
                    enabled: false
                },
                top: candleHeight,
                height: volumeHeight
            }],
            plotOptions: {                
                line: {
                	tooltip: {pointFormat:''}
                },
                column: {
                	tooltip: {pointFormat:''}
                }
            },
            series: [{
            	id: 'stock',
                type: 'candlestick',
                name: '주가',
                data: ohlc,
                yAxis : 0
            }, {
            	id: 'bDay5',
                type: 'line',
                lineWidth : 1,
                name: '5',
                color: '#E4635E',
                data: bDay5,
                yAxis : 0
            }, {
            	id: 'bDay10',
                type: 'line',
                lineWidth : 1,
                name: '10',
                color: '#CB65D2',
                data: bDay10,
                yAxis : 0
            }, {
            	id: 'volume',
                type: 'column',
                name: 'Volume',
                data: volume,
                yAxis : 1
            }]
        });
        
        return rtnChart;
    },
    
    chartHogaReal : function(chartList, data) {
    	var openPrc = data[0]; // 시가
        var highPrc = data[1]; // 고가
        var lowPrc = data[2]; // 저가
        var currPrc = data[3]; // 현재가
        var concQty = data[4]; // 누적거래량
        
        var chart10_data1 = [];	// candle
        var chart10_data2 = [];	// volume
        
        var chart10_data5 = [];	// 5 이평
        var chart10_data10 = []; // 10 이평
        
        if(typeof chartList != 'undefined' && chartList != null) {
    	    var chart10hoga = chartList.chart;
    	    var lastLen = chartList.chartData.length -1;
    	    
    	    if(data != null) {
    	    	chartList.chartData[lastLen] = [
    				Number(chartList.currDate), // 날짜
    				Number(openPrc),			// 시가
    				Number(highPrc),			// 고가
    				Number(lowPrc),				// 저가
    				Number(currPrc),			// 현재가
    				Number(concQty)				// 거래량
    	    	];
    	    	
    	    	chart10_data1.push(
	                Number(chartList.currDate),	// 날짜
	                Number(openPrc),			// 시가
	                Number(highPrc),			// 고가
	                Number(lowPrc),				// 저가
	                Number(currPrc)				// 현재가
    	        );
    	        
    	    	chart10_data2.push(
    	    		Number(chartList.currDate),
    	    		Number(concQty)
    	        );
    	    	
    	        // 5이평
    		    if(lastLen + 1 >= 5) {
        		    var dataSum5 = 0;
        		    for (var i = 0; i < 5; i++) {
        		    	dataSum5 += chartList.chartData[lastLen - i][4];
        		    }
        		    chart10_data5.push( Number(chartList.currDate), Number((dataSum5 / 5).toFixed(2)) ); //날짜, 5이평
    		    } else {
    		    	chart10_data5.push( Number(chartList.currDate), null );
    		    }
    		    
    		    // 10이평
    		    if(lastLen + 1 >= 10) {
    		    	var dataSum10 = 0;
    		        for (var i = 0; i < 10; i++) {
                        dataSum10 += chartList.chartData[lastLen - i][4];
                    }
    		        chart10_data10.push( Number(chartList.currDate), Number((dataSum10 / 10).toFixed(2)) ); //날짜, 10이평
    		    } else {
    		    	chart10_data10.push( Number(chartList.currDate), null );
    		    }
    	        
    	        if(chart10_data1 != null && chart10_data1.length > 0) {
    	        	var len_chart10 = chart10hoga.get('stock').data.length;
    	        	var lastDataTimeUtc = chart10hoga.get('stock').data[len_chart10-1].x;
    	            	
    	            if( lastDataTimeUtc == chart10_data1[0] && len_chart10 > 0) {
						chart10hoga.get('stock').data[len_chart10-1].update(chart10_data1.slice(), false, false, false);
						chart10hoga.get('volume').data[chart10hoga.get('volume').data.length - 1].update(chart10_data2.slice(), false, false, false);
						chart10hoga.get('bDay5').data[chart10hoga.get('bDay5').data.length - 1].update(chart10_data5.slice(), false, false, false);
						chart10hoga.get('bDay10').data[chart10hoga.get('bDay10').data.length - 1].update(chart10_data10.slice(), false, false, false);
						chart10hoga.redraw();
    	            }
    	        }
    	    }
        }
    }
  };

  Highcharts.setOptions(nexChartUtils.hichartOptions);

  window.nexChartUtils = nexChartUtils;
})(window)
