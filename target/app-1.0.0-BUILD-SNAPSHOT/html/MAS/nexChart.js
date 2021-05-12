

	var nexChart = function(options) {

		// 전역 변수

		this._chart; // HighChart Object

		this._data; // 차트 데이터

		this._dataLen; // _data.length 값

		this._renderTo; // 차트 위치(Element node)

		this._screenNum; // 화면 번호

		this._monthSect; // 주기(1=분봉, 2=일봉, 3=주봉, 4=월봉, 7=시봉)

		this._chartWidth; // width 값(px)

		this._chartHeight; // height 값(px)

		this._seriesData; // 현재 생성되어 있는 series

		this._seriesDataCnt; // 현재 생성되어 있는 series 개수

		this._yAxisCnt; // 현재 생성되어 있는 yAxis 개수(최초 y축은 옵션에서 하나 지정(필수))

		this._exceptIdx; // 빈데이터 시작 IDX(현재일 이후 + 26일)

		this._xRange; // 초기 navigator range (utctime)

		this._colors; // 라인 색상

		this._chartOptions; // 추가 옵션

		this._defaultVar; // 차트 수치값

		this._mainType; // 가격차트 종류 (candle, line, ohlc) 

		this._valueDecimals; // 툴팁 소수점



		this.init(options);

	}

	nexChart.prototype = {

	    /**

		 * desc : 초기화 

		 * date : 2015.07.22

		 */

	    init: function(options) {

			this._data = options.data;

			this._dataLen = options.data.length;

			this._renderTo = options.renderTo[0];

			this._monthSect = options.monthSect || '2';

			this._chartWidth = options.width || 600;

			this._chartHeight = options.height || 470;

			this._screenNum = options.screenNum;

			this._seriesData = [];

			this._seriesDataCnt = 0;

			this._yAxisCnt = 1;

			this._exceptIdx = 0;

			this._xRange = options.dataKind=='1' ? null : this._dataLen > 46 ? this._data[this._dataLen - 1][0] - this._data[parseInt(this._dataLen - (this._dataLen/4))][0] : null;

			this._chartOptions = options.chartOptions || null;

			this._colors = Highcharts.getOptions().colors;

			this._mainType = options.mainType || "candle";

			this._valueDecimals = options.valueDecimals || "2";
			
			this._etcOption = options.etcOption || 'N';

			this._defaultVar = options.seriesData || { // 지표 설정 기본값

			   	'candle'	: null, // 가격차트

			   	'volume'	: null, // 거래량

			   	'sma'		: [{name:'MA1',value:5,lineColor:'#76B448',lineWidth:'0.8'}, // 이동평균

			   	     		   {name:'MA2',value:20,lineColor:'#E03433',lineWidth:'0.8'},

			   	     		   {name:'MA3',value:60,lineColor:'#337FE5',lineWidth:'0.8'},

			   	     		   {name:'MA4',value:120,lineColor:'#FF59AC',lineWidth:'0.8'},

			   	     		   {name:'MA5',value:200,lineColor:'#0059AC',lineWidth:'0.8'}],

			   	'cna'		: [{name:'전환선',value:9},{name:'기준,후,선',value:26},{name:'선행스팬',value:52}], // 일목균형

			   	'bollinger'	: [{name:'이평기간',value:20},{name:'표준편차승수',value:2}], // 볼린저밴드

			   	'parabolic'	: [{name:'AF최대값',value:0.2}], // Parabolic SAR

			   	'envelope'	: [{name:'기간',value:20},{name:'가감값',value:5}], // 엔벨로프

			   	'maribbon'	: [{name:'시작이평',value:5},{name:'증가',value:2},{name:'갯수',value:10}], // 그물차트

			   	'macd'		: [{name:'단기이평',value:12},{name:'장기이평',value:26},{name:'Signal',value:9}], // MACD

			   	'slowStc'	: [{name:'기간',value:5},{name:'Slow%K',value:3},{name:'Slow%D',value:3}], // stochastic slow

			   	'fastStc'	: [{name:'fast%K',value:5},{name:'fast%D',value:3}], // stochastic fast

			   	'cci'		: [{name:'기간',value:14},{name:'Signal',value:9}], // CCI

			   	'mental'	: [{name:'기간',value:10},{name:'Signal',value:15}], // 심리도

			   	'adx'		: [{name:'기간',value:14}], // ADX

			   	'obv'		: [{name:'Signal',value:9}], // OBV

			   	'sonar'		: [{name:'이평기간',value:14},{name:'비교기간',value:26},{name:'Signal',value:9}], // SONAR

			   	'vr'		: [{name:'기간',value:20}], // VR

			   	'trix'		: [{name:'기간',value:12},{name:'Signal',value:9}], // TRIX

			   	'roc'		: [{name:'기간',value:12},{name:'시그널',value:9}], // ROC

			   	'williams'	: [{name:'williams %R',value:14},{ name:'Signal',value:9}], // Williams '%R

			   	'rsi'		: [{name:'기간',value:14},{name:'Signal',value:6}], // RSI

			   	'dis'		: [{name:'이격1',value:5},{name:'이격2',value:10},{name:'이격3',value:20},{name:'이격4',value:40}], // 이격도

				'dmi'		: [{name:'기간',value:14}] // DMI

			};

			this._chart = new Highcharts.StockChart(this.getChartTypeOption(this._renderTo, this._monthSect, this._xRange, this._chartWidth, this._chartHeight, this._chartOptions,this._etcOption));



			// 최초 candle차트 생성

			this.addSeries("candleSeries", "mainYaxis", null, this._mainType);

		},

	    /**

		 * desc : 사이즈 변경 

		 * date : 2016.04.07

		 */

		setSize : function(width, height) {

			this._chart.setSize(width, height);

		},

		/**

		 * desc : 데이터 반환 

		 * date : 2015.07.22

		 * 

		 * @return _data : 차트 데이터

		 */

		getData : function() {

			return this._data;

		},

		/**

		 * desc : 데이터 반환 

		 * date : 2015.07.22

		 * 

		 * @return _data : 차트 데이터

		 */

		getDataLength : function() {

			var rtn_len = this._dataLen;

			// 빈데이터(현재일 + 26일) 있을 경우 빈데이터 이전까지 데이터 크기

			if (this._exceptIdx != 0) {

				rtn_len = this._exceptIdx;

			}

			return rtn_len;

		},

	    /**

		 * desc : 가장 최근 데이터의 UTC 시간 반환

		 * date : 2015.07.22

		 * 

		 * @return {number} : UTC 시간

		 */

	    getLastDataTimeUtc: function() {

	    	if (this.getDataLength() > 0) {

	    		if (this._exceptIdx != 0) {// 빈데이터(현재일 + 26일)가 있을 경우 마지막 날짜로 현재일 세팅

	    			return this._data[this._exceptIdx - 1][0];

	    		} else { 

	    			return this._data[this.getDataLength() - 1][0];

	    		}

	    	}

	    },

	    /**

	     * desc : 빈 데이터 시작 IDX 반환

	     * date : 2015.07.22

	     * 

	     * @return _exceptIdx

	     */

	    getExceptIdx: function() {

	    	return this._exceptIdx;

	    },	

	    /**

	     * desc : 차트 메인 옵션

	     * date : 2016.01.13

	     * 

		 * @param typeOptions : 차트 커스텀 옵션, null일 경우 종합차트 옵션값(totChartOptions)으로 셋팅

		 * 

	     * @return 차트 옵션 객체

	     */

	    getChartTypeOption: function(renderTo, monthSect, xRange, width, height, customOptions,etcOption) {

	    	// 기본옵션

	    	var defaultOptions = {

    			chart: {

    				panning: true, //zoom 설정과 연계되는 움직임 설정(zoom을 하지 않을경우 이것두 false로 설정해야 움직임이 없어진다)

    				renderTo: renderTo,

    				zoomType: 'x', //zoom 설정(x,y,xy)

    				height: height,

    				width: width

    			},

    			navigator : {

					enabled : true,

					height : 14,

					margin : 0,

					baseSeries:1, // default:0 --> 캔들스틱 사라지는 버그

					xAxis: {

	                    ordinal: true,

	                    tickWidth: 0,

	                    lineWidth: 0,

	                    minorTickLength: 0,

	                    gridLineWidth: 0,

	                    labels: {

	                        enabled: false

	                    }

	                }

				},

    			tooltip : {

					crosshairs : [ true, false ], // 화면에서 마우스 라인

					shared : true, // 한번의 툴팁으로 여러 그래프를 표현.

					positioner : null,

					xDateFormat : nexChartUtils.getHederTimeFormat(monthSect)

				},

				plotOptions : { // series 옵션의 글로벌 선언부(여기 있는 모든 옵션값은 series에 개별 정의가능)

					series : {

						states : {

							hover : {

								enabled : false,

								lineWidth : 0.8

							// 라인에 마우스 올렸을때 크기

							}

						},

						dataGrouping : {

							enabled : false

						// 데이터 그룹핑 여부 [default(line:avg, colum:sum ...)

						}

					}

				},

				xAxis : {

					range : xRange,

					startOnTick : false, // 최초 x라벨 표시 여부(min을 설정하면 이값은 무시된다)

					gridLinedashStyle : 'dot',

					gridLineWidth : 0, // 그리드 라인 크기

					labels: {

	                    align: 'left'

	                },

					minorTickLength : 0// 보여지는 라벨과 라벨사이의 틱의 갯수

				},

				scrollbar : {

					enabled : false,

					margin : 0

				},

				yAxis : {

					id : 'mainYaxis',

					lineWidth : 1,

					opposite : true, // true:y라벨 오른쪽, false:y라벨 왼쪽

					showFirstLabel : false,

					gridLinedashStyle : 'dot',// 대쉬 스타일

					top : 25,

					height : height - 70,

					minorTickLength : 5, // 보여지는 라벨과 라벨사이의 틱의 갯수

					tickPixelInterval : 50,

					labels : {

						enabled : true,

						align : 'left',

						formatter : function() {

							var valueData = this.value;

							return Highcharts.numberFormat(valueData, 0);

						},

						x : 10,

						y : 5

					}

				},

				rangeSelector : {

					enabled : false

				},

				legend : {

					enabled : true,

					padding : 0,

					margin : 0,

					x : 0,

					y : -15

				}

			};
	    	
	    	if(etcOption == 'Y'){	    		
	    		defaultOptions.legend.enabled = false;	
	    		//console.log(defaultOptions);
	    	}



			if (customOptions !== undefined && customOptions != null) {

				defaultOptions = Highcharts.merge(true, defaultOptions, customOptions);

			}



			return defaultOptions;

	    },

	    /**

		 * desc : 차트 yAxis 옵션 

		 * date : 2015.07.22

		 * 

		 * ex : getChartYAxisOption('volumeYaxis'); -> volumeYaxis 옵션 설정 후 그 값 반환

		 * 

		 * @param axisId :

		 *            id

		 * @return 차트 옵션 객체

		 */

	    getChartYAxisOption: function(axisId, customOptions) {

	    	var defaultOptions = {

				id : axisId,

				lineWidth : 1,

				opposite : true, // true:y라벨 오른쪽, false:y라벨 왼쪽

				showFirstLabel : false,

				gridLinedashStyle : 'dot',

				zIndex : 1000, // 대쉬 스타일

				gridLineWidth : 1,

				labels : {

					enabled : true,

					align : 'left',

					formatter : function() {

						return nexUtils.numberWithCommas(this.value);

					},

					x : 10,

					y : 5

				},

				offset : 0,

				minorTickLength : 0,

				tickPixelInterval : 30

			};



			if (customOptions !== undefined) {

				defaultOptions = Highcharts.merge(true, defaultOptions, customOptions);

			}



			return defaultOptions;

		},

	    setLineOption: function(seriesId, color, lineWidth) {

	    	this._chart.get(seriesId).update({

	    		color: color,

	    		lineWidth: lineWidth

	    	});

	    	this._chart.redraw();

	    },

	    getLineOption: function(type) {

	    	var option = {};

	    	

	   	    switch (type) { // 차트별 옵션 적용

	   	    case 'candle': // 캔들스틱

				option.type = 'candlestick';

				break;

			case 'ohlc': // 캔들스틱

				option.type = 'ohlc';

				break;

			case 'line': // 캔들스틱

				option.type = 'line';

				option.color = '#FF00FF';

				break;

			case 'volume': // 거래량( UP )

				option.type = 'column';

				option.valueDecimals = "0";

				option.color = this._colors[0];

				break;

			case 'volume1': // 거래량( DOWN )

				option.type = 'column';

				option.color = this._colors[1];

				break;

			case 'sma1': // 이동평균( 5 이평 )

				option.color = this._defaultVar.sma[0].lineColor;

				option.lineWidth = this._defaultVar.sma[0].lineWidth;

				break;

			case 'sma2': // 이동평균( 20 이평 )

				option.color = this._defaultVar.sma[1].lineColor;

				option.lineWidth = this._defaultVar.sma[1].lineWidth;

				break;

			case 'sma3': // 이동평균( 60 이평 )

				option.color = this._defaultVar.sma[2].lineColor;

				option.lineWidth = this._defaultVar.sma[2].lineWidth;

				break;

			case 'sma4': // 이동평균 ( 120 이평 )

				option.color = this._defaultVar.sma[3].lineColor;

				option.lineWidth = this._defaultVar.sma[3].lineWidth;

				break;

			case 'sma5': // 이동평균 ( 200 이평 )

				option.color = this._defaultVar.sma[4].lineColor;

				option.lineWidth = this._defaultVar.sma[4].lineWidth;

				break;

			case 'cna1': // 일목균형 ( 기준선 )

				option.color = this._colors[0];

				break;

			case 'cna2': // 일목균형 ( 전환선 )

				option.color = this._colors[5];

				break;

			case 'cna3': // 일목균형 ( 후행스팬 )

				option.color = this._colors[4];

				break;

			case 'cna4': // 일목균형 ( 단기선행스팬 )

				option.color = this._colors[9];

				break;

			case 'cna5': // 일목균형 ( 장기선행스팬 - 단기선행스팬 구름대 )

				option.type = 'columnrange';

				option.color = this._colors[10];

				break;

			case 'cna6': // 일목균형 ( 단기선행스팬 - 장기선행스팬 구름대 )

				option.type = 'columnrange';

				option.color = this._colors[9];

				break;

			case 'cna7': // 일목균형 ( 장기선행스팬 )

				option.color = this._colors[10];

				break;

			case 'bollinger1': // bollingerBand ( 상한선 )

				option.lineWidth = 2;

				option.color = this._colors[7];

				break;

			case 'bollinger2': // bollingerBand ( 중심선 )

				option.lineWidth = 2;

				option.color = this._colors[5];

				break;

			case 'bollinger3': // bollingerBand ( 하한선 )

				option.lineWidth = 2;

				option.color = this._colors[8];

				break;

			case 'envelope1': // Envelope ( 상한선 )

				option.lineWidth = 2;

				option.color = this._colors[7];

				break;

			case 'envelope2': // Envelope ( 중심선 )

				option.lineWidth = 2;

				option.color = this._colors[5];

				break;

			case 'envelope3': // Envelope ( 하한선 )

				option.lineWidth = 2;

				option.color = this._colors[8];

				break;

			case 'parabolic': // Envelope ( 하한선 )

				option.type = 'line'

				option.color = "#FFFFFF";

				option.lineWidth = 0.001;

				option.marker = {

                    enabled: true,

                    radius: 2.5,

                    symbol: 'circle'

                },

				option.color = this._colors[0];

				option.valueDecimals = 2;

				break;

			case 'maribbon': // 그물차트

				option.color = this._colors[17];

				break;

			case 'macd1': // MACD ( MACD )

				option.valueDecimals = 2;

				option.color = this._colors[7];

				break;

			case 'macd2': // MACD ( Signal )

				option.valueDecimals = 2;

				option.color = this._colors[12];

				break;

			case 'macd3': // MACD ( OSC )

				option.valueDecimals = 2;

				option.type = 'column';

				option.color = this._colors[7];

				break;

			case 'slowstc1': // SlowStc ( Slow %K )

				option.valueDecimals = 2;

				option.color = this._colors[0];

				break;

			case 'slowstc2': // SlowStc ( Slow %D )

				option.valueDecimals = 2;

				option.color = this._colors[5];

				break;

			case 'faststc1': // FastStc ( Fast %K )

				option.valueDecimals = 2;

				option.color = this._colors[0];

				break;

			case 'faststc2': // FastStc ( Fast %D )

				option.valueDecimals = 2;

				option.color = this._colors[5];

				break;

			case 'cci1': // cci

				option.valueDecimals = 2;

				option.color = this._colors[0];

				break;

			case 'cci2': // cci (시그널선)

				option.valueDecimals = 2;

				option.color = this._colors[12];

				break;

			case 'mental1': // 투자심리 ( 심리도 )

				option.color = this._colors[0];

				break;

			case 'mental2': // 투자심리 ( 시그널 )

				option.color = this._colors[12];

				break;

			case 'adx1': // ADX ( PDI )

				option.valueDecimals = 2;

				option.color = this._colors[1];

				break;

			case 'adx2': // ADX ( MDI )

				option.valueDecimals = 2;

				option.color = this._colors[5];

				break;

			case 'adx3': // ADX ( ADX )

				option.valueDecimals = 2;

				option.color = this._colors[0];

				break;

			case 'obv1': // OBV ( OBV )

				option.color = this._colors[0];

				break;

			case 'obv2': // OBV ( 시그널선 )

				option.color = this._colors[12];

				break;

			case 'sonar1': // SONAR ( SONAR )

				option.valueDecimals = 2;

				option.color = this._colors[0];

				break;

			case 'sonar2': // SONAR ( Signal )

				option.valueDecimals = 2;

				option.color = this._colors[12];

				break;

			case 'vr': // VR ( VR )

				option.color = this._colors[0];

				option.valueDecimals = 2;

				break;

			case 'trix1': // TRIX ( TRIX )

				option.valueDecimals = 2;

				option.color = this._colors[0];

				break;

			case 'trix2': // TRIX ( Signal )

				option.valueDecimals = 2;

				option.color = this._colors[12];

				break;

			case 'roc1': // ROC ( ROC )

				option.color = this._colors[0];

				option.valueDecimals = 2;

				break;

			case 'roc2': // ROC ( Signal )

				option.color = this._colors[12];

				option.valueDecimals = 2;

				break;

			case 'rsi1': // RSI ( RSI )

				option.color = this._colors[0];

				option.valueDecimals = 2;

				break;

			case 'rsi2': // RSI ( Signal )

				option.color = this._colors[12];

				option.valueDecimals = 2;

				break;

			case 'williams1':

				option.color = this._colors[0];

				option.valueDecimals = 2;

				break;

			case 'williams2':

				option.color = this._colors[5];

				option.valueDecimals = 2;

				break;

			case 'dis1': // 이격도1

				option.color = this._colors[13];

				option.valueDecimals = 2;

				break;

			case 'dis2': // 이격도2

				option.color = this._colors[14];

				option.valueDecimals = 2;

				break;

			case 'dis3': // 이격도3

				option.color = this._colors[15];

				option.valueDecimals = 2;

				break;

			case 'dis4': // 이격도4

				option.color = this._colors[16];

				option.valueDecimals = 2;

				break;

			case 'dmi1': // DMI (UpDI)

				option.color = this._colors[0];

				option.valueDecimals = 2;

				break;6

			case 'dmi2': // DMI (DownDI)

				option.color = this._colors[1];

				option.valueDecimals = 2;

				break;

			default:

				option = {};

				break;

	        }

	   	    return option;

	    },

	    /**

		 * desc : 차트 시리즈(지표,보조차트)별 옵션설정 

		 * date : 2015.07.22

		 * 

		 * ex : getChartSeriesOption('candle', 'candleSeries', '가격', 'candleYaxis', {data}, false);

		 * 

		 * @param type : 차트타입

		 * @param seriesId : 시리즈 id

		 * @param seriesNm : 시리즈명

		 * @param yAxisId : 그려질 y축 id

		 * @param data : 데이터

		 * @param legend : 범례 표현 flag(true, false)

		 * @return 차트 옵션 객체

		 */

	    getChartSeriesOption: function(type, seriesId, seriesNm, yAxisId, data, legend) {

	    	var lineOption = this.getLineOption(type);



			var show_legend = (legend == false) ? false : true;

			var type = lineOption.type || 'line';

			var color = lineOption.color;

			var lineWidth = lineOption.lineWidth || '0.8';

			var valueDecimals = lineOption.valueDecimals || this._valueDecimals;

			var marker = lineOption.marker || {enabled: false};

			var option = { // 기본 옵션

				type : type,

				id : seriesId,

				name : seriesNm,

				yAxis : yAxisId,

				showInLegend : show_legend,

				data : data.slice(),

				lineWidth : lineWidth,

				marker : marker,

				tooltip : {

					valueDecimals : valueDecimals

				}

			}

			if (color !== undefined) {

				option.color = color;

			}



			return option;

		},

	    /**

		 * desc : PlotLine(보조선) 옵션 반환 

		 * date : 2015.07.22

		 * 

		 * ex : getPlotLineOption('slowStc');

		 * 

		 * @param type : 화면번호

		 * @param axisId : id

		 * @return 차트 옵션 객체

		 */

		getPlotLineOption : function(type) {

			var lineOptions = [];

			var lineOption = function(value, color) {

				return {

					color : color || '#000000',

					value : value,

					dashStyle : 'line',

					zIndex : 1,

					width : 1,

					label : {

						style : {

							font : '11px "맑은 고딕",Dotum,"굴림",Gulim,AppleGothic,Arial,Helvetica,sans-serif',

							color : color || '#000000'

						},

						text : value

					}

				}

			}

			switch (type) {

			case 'slowStc':

			case 'fastStc':

				lineOptions[0] = lineOption(20);

				lineOptions[1] = lineOption(80);

				break;

			case 'dis':

				lineOptions[0] = lineOption(100);

				lineOptions[1] = lineOption(90);

				break;

			case 'cci':

				lineOptions[0] = lineOption(100);

				lineOptions[1] = lineOption(-100);

				break;

			case 'mental':

				lineOptions[0] = lineOption(75);

				lineOptions[1] = lineOption(25);

				break;

			case 'cci':

			case 'adx':

				lineOptions[0] = lineOption(20);

				break;

			case 'williams':

				lineOptions[0] = lineOption(-20);

				lineOptions[1] = lineOption(-80);

				break;

			case 'vr':

				lineOptions[0] = lineOption(150);

				lineOptions[1] = lineOption(75);

				break;

			case 'roc':

				lineOptions[0] = lineOption(100);

				break;

			case 'rsi':

				lineOptions[0] = lineOption(70);

				lineOptions[1] = lineOption(30);

				break;

			case 'dmi':

				lineOptions[0] = lineOption(30);

				lineOptions[1] = lineOption(10);

				break;

			case 'obv':

			case 'sonar':

			case 'trix':

			case 'macd':

				lineOptions[0] = lineOption(0);

				break;

			default:

				return null;

			}

			return lineOptions;

		},

	    /**

		 * desc : y축 추가 

		 * date : 2015.07.22

		 * 

		 * @param yAxisId : y축 id ('slowStcYaxis','mainYaxis',...)

		 */

		addYAxis : function(yAxisId) {

			var option = this.getChartYAxisOption(yAxisId);

			this._chart.addAxis(option, false, false, false);

			this._yAxisCnt++;

			this.reSizeHeight();

		},

		/**

		 * desc : y축 삭제 

		 * date : 2015.07.22

		 * 

		 * @param yAxisId : y축 id ('slowStcYaxis','mainYaxis',...)

		 */

		removeYAxis : function(yAxisId) {

			this._chart.get(yAxisId).remove(false);

			this._yAxisCnt--;

			this.reSizeHeight();

		},

	    /**

		 * desc : 차트 높이값 설정 

		 * date : 2015.07.22

		 * 

		 */

		reSizeHeight : function() {

			// 모든 yAxis에 대해서 height,top 재수정

			var total_height = this._chartHeight;

			var axis_height = 100;

			var candle_height = total_height - ((this._yAxisCnt - 1) * (axis_height + 5)) - 65;



			this._chart.yAxis[0].update({

				top : 25,

				height : candle_height + 3

			}, false);



			var yAxis = this._chart.yAxis;

			for (var i = 1, cnt = 0, len = yAxis.length; i < len; i++) {

				if (yAxis[i].options.id != 'navigator-y-axis') {

					yAxis[i].update({

						top : candle_height + (cnt * (axis_height + 5)) + 33, // secondTop

						height : axis_height

					}, false);

					cnt++;

				}

			}

		},

	    /**

		 * desc : 새로운 시리즈 추가 

		 * date : 2015.07.22

		 * 

		 * @param seriesId : 지표 또는 보조차트 시리즈 ID ('candleSeries', 'volumeSeries', ...)

		 * @param seriesData : 시리즈 설정값(이동평균지표의 경우: [5, 20, 60, 120])

		 * @param yAxisId : 지표 또는 보조차트 Y축 ID('mainYaxis', 'slowStcYaxis' , ...)

		 * @param mainType : 가격 차트 TYPE ( candle, ohlc, line )

		 */

	    addSeries: function(seriesId, yAxisId, seriesData, mainType) {

	    	var index = this.getSeriesDataIndex(seriesId);

	    	var options = [];

	    	if (seriesData == null) {

	    		if(this._defaultVar[seriesId.split('Series')[0]] != null) {

	    			seriesData = [];

	    			for( var i=0; i<this._defaultVar[seriesId.split('Series')[0]].length; i++) {

	    				seriesData.push(Number(this._defaultVar[seriesId.split('Series')[0]][i].value));

	    			}

	    		}

	    	} 

	      		

	    	if (index != null) {

	    		return;

	    	}

	

	    	switch (seriesId) {

        	case 'candleSeries': // 캔들 시리즈 추가

        		this._seriesData[this._seriesDataCnt] = new candleData(this, seriesId, this._data);

        		this._exceptIdx = this._seriesData[this._seriesDataCnt].getExceptIdx();

          

        		options[0] = this.getChartSeriesOption(mainType, seriesId, '가격', yAxisId, this._seriesData[this._seriesDataCnt].getData());

        		break;

	        case 'smaSeries': // sma(이동평균) 시리즈 추가.

	        	var sma_nums = seriesData; //이동평균 수치 배열 (예) [5,20,60,120,200]

	          

	        	this._seriesData[this._seriesDataCnt] = new smaData(this, seriesId, this._data, sma_nums);

	

	        	for(var i=0;i<sma_nums.length;i++){

	        		var series_no = i+1;

	        		options[i] = this.getChartSeriesOption('sma'+series_no, seriesId+'_'+series_no, sma_nums[i].toString(), yAxisId, this._seriesData[this._seriesDataCnt].getData(series_no));

	        	}

	          

	        	break;

	        case 'cnaSeries': // cna(일목균형) 시리즈 추가.

	        	 //일목균형 수치 배열 (기준선, 전환선, 후행스팬, 단기선행스팬, 장기선행스팬)

	            var sma_nums = [];

	            

	            sma_nums.push(seriesData[1]);//기준선

	            sma_nums.push(seriesData[0]);//전환선

	            sma_nums.push(seriesData[1]);//후행스팬 

	            sma_nums.push(seriesData[1]);//선행스팬

	            sma_nums.push(seriesData[2]);//장기선행

	

	            this._seriesData[this._seriesDataCnt] = new cnaData(this, seriesId, this._data, sma_nums);

	            options[0] = this.getChartSeriesOption('cna1', seriesId + '_1', '기준선(' + sma_nums[0].toString() + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));

	            options[1] = this.getChartSeriesOption('cna2', seriesId + '_2', '전환선(' + sma_nums[1].toString() + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

	            options[2] = this.getChartSeriesOption('cna3', seriesId + '_3', '후행스팬(' + sma_nums[2].toString() + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(3));

	            options[3] = this.getChartSeriesOption('cna4', seriesId + '_4', '단기선행스팬(' + sma_nums[3].toString() + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(4));

	            options[4] = this.getChartSeriesOption('cna5', seriesId + '_5', '장기선행스팬(' + sma_nums[4].toString() + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(5), false);

	            options[5] = this.getChartSeriesOption('cna6', seriesId + '_6', '단기선행스팬(' + sma_nums[3].toString() + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(6), false);

	            options[6] = this.getChartSeriesOption('cna7', seriesId + '_7', '장기선행스팬(' + sma_nums[4].toString() + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(7));

	

	            break;

	        case 'bollingerSeries': // Bollinger Band 시리즈 추가.

	        	var sma_num1 = seriesData[0]; // 이동평균기간

	        	var sma_num2 = seriesData[1]; // 표준평차승수

	

	        	this._seriesData[this._seriesDataCnt] = new bollingerData(this, seriesId, this._data, sma_num1, sma_num2);

	        	options[0] = this.getChartSeriesOption('bollinger1', seriesId + '_1', 'BB_상한선(' + sma_num1 + ',' + sma_num2 + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));

	        	options[1] = this.getChartSeriesOption('bollinger2', seriesId + '_2', 'BB_중심선', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

	        	options[2] = this.getChartSeriesOption('bollinger3', seriesId + '_3', 'BB_하한선', yAxisId, this._seriesData[this._seriesDataCnt].getData(3));

			

	        	break;

	        case 'envelopeSeries': // envelope 시리즈 추가.

	        	var sma_num = seriesData[0], // 이동평균 수치

	            factor = seriesData[1]; // 가감값

	

	        	this._seriesData[this._seriesDataCnt] = new envelopeData(this, seriesId, this._data, sma_num, factor);

	        	options[0] = this.getChartSeriesOption('envelope1', seriesId + '_1', 'E_상한선(' + sma_num + ',' + factor + ',' + factor + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));

	        	options[1] = this.getChartSeriesOption('envelope2', seriesId + '_2', 'E_중심선', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

	        	options[2] = this.getChartSeriesOption('envelope3', seriesId + '_3', 'E_하한선', yAxisId, this._seriesData[this._seriesDataCnt].getData(3));

	

	        	break;

	        case 'parabolicSeries': // envelope 시리즈 추가.

	            var afmax = seriesData[0]; // AF 최대값

	

	            this._seriesData[this._seriesDataCnt] = new parabolicData(this, seriesId, this._data, afmax);

	            options[0] = this.getChartSeriesOption('parabolic', seriesId, 'PSAR(0.02, ' + afmax + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData());

	

	            break;

	        case 'maribbonSeries': // 그물 시리즈 추가.

	        	var sma_num = seriesData[0]; // 이동평균

	            var inc = seriesData[1]; // 증가값

	            var rCnt = seriesData[2]; // 계수

	            var option;

	            var that = this;

	

	            this._seriesData[this._seriesDataCnt] = new maRibbonData(this, seriesId, this._data, sma_num, inc, rCnt);

	

	            for (var i = 0, len = rCnt; i < len; i++) {

	            	var legend = false;

	            	if (i == 0) {

	            		legend = true;

	            		option = this.getChartSeriesOption('maribbon', seriesId + '_' + (i + 1), '그물차트(' + sma_num + ',' + inc + ',' + rCnt + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(i), legend);

	            	} else {

	            		option = this.getChartSeriesOption('maribbon', seriesId + '_' + (i + 1), '그물차트' + (i + 1), yAxisId, this._seriesData[this._seriesDataCnt].getData(i), legend);

	            	}

	

	            	option.events = { 

            			legendItemClick: function(e) {

            				for (var j = 0; j < rCnt; j++) {

            					if (that._chart.get(seriesId + '_' + (j + 1)).visible == true) {

            						that._chart.get(seriesId + '_' + (j + 1)).setVisible(false, false);

            					} else {

            						that._chart.get(seriesId + '_' + (j + 1)).setVisible(true, false);

            					}

            				}

            				return false;

            			}

	            	};

	

	            	this._chart.addSeries(option, false, false);

	            }

	

	            this._seriesDataCnt++;

	

	            break;

        	case 'volumeSeries':

        		this._seriesData[this._seriesDataCnt] = new volumeData(this, seriesId, this._data);

        		options[0] = this.getChartSeriesOption('volume', seriesId, '거래량', yAxisId, this._seriesData[this._seriesDataCnt].getData(), false);

	

        		break;

	        case 'macdSeries':

	        	var emaNum1 = seriesData[0]; // 단기이평

	            var emaNum2 = seriesData[1]; // 장기이평

	            var signal = seriesData[2]; // signal

	

	            this._seriesData[this._seriesDataCnt] = new macdData(this, seriesId, this._data, emaNum1, emaNum2, signal);

	            options[0] = this.getChartSeriesOption('macd1', seriesId + '_1', 'MACD(' + emaNum1 + ',' + emaNum2 + ',' + signal + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));

	            options[1] = this.getChartSeriesOption('macd2', seriesId + '_2', 'Signal', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

	            options[2] = this.getChartSeriesOption('macd3', seriesId + '_3', 'MACD Oscillator', yAxisId, this._seriesData[this._seriesDataCnt].getData(3), false);

	

	            break;

	        case 'slowStcSeries': // slowStc 시리즈 추가.

	        	var day = seriesData[0]; // 기간

	            var slowK = seriesData[1]; // Slow %K 구간

	            var slowD = seriesData[2]; // Slow %D 구간

	

	            this._seriesData[this._seriesDataCnt] = new slowStcData(this, seriesId, this._data, day, slowK, slowD);

	            options[0] = this.getChartSeriesOption('slowstc1', seriesId + '_1', 'Sto Slow %K(' + day + ',' + slowK + ',' + slowD + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

	            options[1] = this.getChartSeriesOption('slowstc2', seriesId + '_2', 'Sto %D', yAxisId, this._seriesData[this._seriesDataCnt].getData(3));

	

	            break;

	        case 'fastStcSeries': // fastStc 시리즈 추가.

	        	var fastK = seriesData[0]; // Fast %K 기간

	        	var fastD = seriesData[1]; // Fast %D 기간

	        	

	        	this._seriesData[this._seriesDataCnt] = new fastStcData(this, seriesId, this._data, fastK, fastD);

	        	options[0] = this.getChartSeriesOption('faststc1', seriesId + '_1', 'Sto Fast %K(' + fastK + ',' + fastD + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));

	        	options[1] = this.getChartSeriesOption('faststc2', seriesId + '_2', '%D', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

	        	

	        	break;

	        case 'cciSeries': // CCI 시리즈 추가.

	        	var day = seriesData[0]; // 기간

	        	var signal = seriesData[1]; // 기간

	

	        	this._seriesData[this._seriesDataCnt] = new cciData(this, seriesId, this._data, day, signal);

	        	options[0] = this.getChartSeriesOption('cci1', seriesId + '_1', 'CCI(' + day + ',' + signal + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(3));

	        	options[1] = this.getChartSeriesOption('cci2', seriesId + '_2', 'Signal', yAxisId, this._seriesData[this._seriesDataCnt].getData(4));

	

	        	break;

	        case 'mentalSeries': // 투자심리 시리즈 추가.

	        	var day = seriesData[0]; // day

	        	var signal = seriesData[1]; // signal

	

	        	this._seriesData[this._seriesDataCnt] = new mentalData(this, seriesId, this._data, day, signal);

	        	options[0] = this.getChartSeriesOption('mental1', seriesId + '_1', '심리도(' + day + ',' + signal + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));

	        	options[1] = this.getChartSeriesOption('mental2', seriesId + '_2', 'Signal', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

	

	        	break;

	        case 'adxSeries': //ADX 시리즈 추가.

	        	var day = seriesData[0]; // 기간

	

	        	this._seriesData[this._seriesDataCnt] = new adxData(this, seriesId, this._data, day);

	        	options[0] = this.getChartSeriesOption('adx1', seriesId + '_1', 'PDI', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));

	        	options[1] = this.getChartSeriesOption('adx2', seriesId + '_2', 'MDI', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

	        	options[2] = this.getChartSeriesOption('adx3', seriesId + '_3', 'ADX(' + day + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(3));

	

	        	break;

	        case 'obvSeries': // OBV 시리즈 추가.

	        	var day = seriesData[0]; // 기간

	

	        	this._seriesData[this._seriesDataCnt] = new obvData(this, seriesId, this._data, day);

	        	options[0] = this.getChartSeriesOption('obv1', seriesId + '_1', 'OBV(' + day + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));

	        	options[1] = this.getChartSeriesOption('obv2', seriesId + '_2', 'Signal', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

	

	        	break;

	        case 'sonarSeries': // SONAR 시리즈 추가.

	        	var emaNum1 = seriesData[0]; // emaNum1

	            var day = seriesData[1]; // 기간

	            var signal = seriesData[2]; //signal

	

	            this._seriesData[this._seriesDataCnt] = new sonarData(this, seriesId, this._data, emaNum1, day, signal);

	            options[0] = this.getChartSeriesOption('sonar1', seriesId + '_1', 'SONAR(' + emaNum1 + ',' + signal + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));

	            options[1] = this.getChartSeriesOption('sonar2', seriesId + '_2', 'Signal', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

	

	            break;

	        case 'vrSeries': //  VR 시리즈 추가.

	        	var day = seriesData[0]; // 기간

	

	        	this._seriesData[this._seriesDataCnt] = new vrData(this, seriesId, this._data, day);

	        	options[0] = this.getChartSeriesOption('vr', seriesId, 'VR(' + day + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData());

	

	        	break;

	        case 'trixSeries': // TRIX 시리즈 추가.

	        	var day = seriesData[0]; // 기간

	            var signal = seriesData[1]; // signal

	

	            this._seriesData[this._seriesDataCnt] = new trixData(this, seriesId, this._data, day, signal);

	            options[0] = this.getChartSeriesOption('trix1', seriesId + '_1', 'TRIX(' + day + ',' + signal + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));

	            options[1] = this.getChartSeriesOption('trix2', seriesId + '_2', 'Signal', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

	

	            break;

	        case 'williamsSeries': // Williams 시리즈 추가.

	        	var day = seriesData[0]; // 기간

	        	var signal = seriesData[1]; // signal

	          

	        	this._seriesData[this._seriesDataCnt] = new williamsData(this, seriesId, this._data, day, signal);

	        	options[0] = this.getChartSeriesOption('williams1', seriesId + '_1', 'william\' %R(' + day + ',' + signal + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));

	        	options[1] = this.getChartSeriesOption('williams2', seriesId + '_2', 'william\' %D', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

	

	        	break;

	        case 'rocSeries': // ROC 시리즈 추가.

	        	var day = seriesData[0]; //기간

	        	var signal = seriesData[1]; // signal

	

	        	this._seriesData[this._seriesDataCnt] = new rocData(this, seriesId, this._data, day, signal);

	        	options[0] = this.getChartSeriesOption('roc1', seriesId + '_1', 'ROC(' + day + ',' + signal + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));

	        	options[1] = this.getChartSeriesOption('roc2', seriesId + '_2', 'Signal', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

	

	        	break;

	        case 'rsiSeries': // RSI 시리즈 추가.

	        	var day = seriesData[0]; //기간

	        	var signal = seriesData[1]; // signal

	        	

	        	this._seriesData[this._seriesDataCnt] = new rsiData(this, seriesId, this._data, day, signal);

	        	options[0] = this.getChartSeriesOption('rsi1', seriesId + '_1', 'RSI(' + day + ',' + signal + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));

	        	options[1] = this.getChartSeriesOption('rsi2', seriesId + '_2', 'Signal', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

	        	

	        	break;

	        case 'disSeries': // 이격도 시리즈 추가.

	        	var dis1 = seriesData[0]; //이격1

	        	var dis2 = seriesData[1]; //이격2

	        	var dis3 = seriesData[2]; //이격3

	        	var dis4 = seriesData[3]; //이격4

	        	

	        	this._seriesData[this._seriesDataCnt] = new disData(this, seriesId, this._data, seriesData);

	        	options[0] = this.getChartSeriesOption('dis1', seriesId + '_1', '이격1(' + dis1 + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));

	            options[1] = this.getChartSeriesOption('dis2', seriesId + '_2', '이격2(' + dis2 + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

	            options[2] = this.getChartSeriesOption('dis3', seriesId + '_3', '이격3(' + dis3 + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(3));

	            options[3] = this.getChartSeriesOption('dis4', seriesId + '_4', '이격4(' + dis4 + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(4));

	        	

	        	break;

	        case 'dmiSeries': // DMI 시리즈 추가.

	        	var day = seriesData[0]; //기간

	        	

	        	this._seriesData[this._seriesDataCnt] = new dmiData(this, seriesId, this._data, day);

	        	options[0] = this.getChartSeriesOption('dmi1', seriesId + '_1', 'UpDI(' + day + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));

	        	options[1] = this.getChartSeriesOption('dmi2', seriesId + '_2', 'DownDI', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

	        	

	        	break;

	    	}

		

	    	if (seriesId == 'maribbonSeries') { // 그물차트일경우 switch문에서 addSeries 처리

	    		return;

	    	}

		

	    	for (var i = 0, len = options.length; i< len; i++) { // highchart library의 addSeries 호출

		        this._chart.addSeries(options[i], false, false);

	    	}

		

	    	var line_options = this.getPlotLineOption(seriesId.split('Series')[0]);

    		if (line_options) { // 보조차트의 기준선 처리

    			for (var i = 0, len = line_options.length; i < len; i++) {

    				this._chart.get(yAxisId).addPlotLine(line_options[i]);

    			}

    		}

	

    		this._seriesDataCnt++;

	    },

	    /**

	     * desc : 시리즈 삭제

	     * date : 2015.07.22

	     * 

	     * @param seriesId : 지표 또는 보조차트 시리즈 ID ('candleSeries', 'volumeSeries', ...)

	     */

	    removeSeries: function(seriesId) {

	    	var index = this.getSeriesDataIndex(seriesId);

	

	    	if (index == null) {

		        return;

	    	}

	

	    	var type = this._seriesData[index].getType();

	

	    	switch (type) {

	    	case 'cna': // 라인 7 개

	    		this._chart.get(seriesId + '_1').remove(false);

	    		this._chart.get(seriesId + '_2').remove(false);

	    		this._chart.get(seriesId + '_3').remove(false);

	    		this._chart.get(seriesId + '_4').remove(false);

	    		this._chart.get(seriesId + '_5').remove(false);

	    		this._chart.get(seriesId + '_6').remove(false);

	    		this._chart.get(seriesId + '_7').remove(false);

	    		break;

	    	case 'maribbon':

	    		for (var i = 0; i < this._seriesData[index].getRcnt(); i++) {

	    			this._chart.get(seriesId + '_' + (i + 1)).remove(false);

	    		}

	    		break;

	    	case 'sma': // 라인 5 개

	    		this._chart.get(seriesId + '_1').remove(false);

	    		this._chart.get(seriesId + '_2').remove(false);

	    		this._chart.get(seriesId + '_3').remove(false);

	    		this._chart.get(seriesId + '_4').remove(false);

	    		this._chart.get(seriesId + '_5').remove(false);

	    		break;

	    	case 'dis': // 라인 4 개

	    		this._chart.get(seriesId + '_1').remove(false);

	    		this._chart.get(seriesId + '_2').remove(false);

	    		this._chart.get(seriesId + '_3').remove(false);

	    		this._chart.get(seriesId + '_4').remove(false);

	    		break;

	    	case 'bollinger': // 라인 3 개

	    	case 'envelope':

	    	case 'adx':

	    	case 'macd':

	    		this._chart.get(seriesId + '_1').remove(false);

	    		this._chart.get(seriesId + '_2').remove(false);

	    		this._chart.get(seriesId + '_3').remove(false);

	    		break;

	    	case 'slowstc': // 라인 2 개

	    	case 'faststc': // 라인 2 개

	    	case 'sonar':

	    	case 'trix':

	    	case 'mental':

	    	case 'obv':

	    	case 'roc':

	    	case 'rsi':

	    	case 'cci':

	    	case 'dmi':

	    	case 'williams':

	    		this._chart.get(seriesId + '_1').remove(false);

	    		this._chart.get(seriesId + '_2').remove(false);

	    		break;

	    	default: // 라인 1 개

	    		this._chart.get(seriesId).remove(false);

	    		break;

	    	}

	      

	    	this._seriesData.splice(index, 1);

	    	this._seriesDataCnt--;

	    },

	    /**

	     * desc : 현재 시리즈 데이터의 개수 반환

	     * date : 2015.07.22

	     * 

	     * @return {Number}

	     */

	    getSeriesDataCnt: function() {

	    	return this._seriesDataCnt;

	    },

	    /**

	     * desc : seriesId에 대한 index 반환

	     * date : 2015.07.22

	     * 

	     * @param seriesId : 지표 또는 보조차트 시리즈 ID ('candleSeries', 'volumeSeries', ...)

	     * @return {Number}

	     */

	    getSeriesDataIndex: function(seriesId) {

	    	var obj = this._seriesData;

	    	for (var i = this._seriesDataCnt; i--;) {

	    		if (obj[i].getId() == seriesId) {

	    			return i;

	    		}

	    	}

	    	return null;

	    },

	    /**

	     * desc : 시리즈 index에 대한 type 반환

	     * date : 2015.07.22

	     * 

	     * @param index

	     * @return type('candle', 'volume', ...)

	     */

	    getSeriesDataType: function(index) {

	    	return this._seriesData[index].getType();

	    },

	    /**

	     * desc : 시리즈 index에 대한 id 반환

	     * date : 2015.07.22

	     * 

	     * @param index

	     * @return seriesId('candleSeries', 'volumeSeries', ...)

	     */

	    getSeriesDataId: function(index) {

	    	return this._seriesData[index].getId();

	    },

	    /**

	     * desc : 실시간 데이터 셋팅

	     * date : 2015.07.22

	     * 

	     * @param pointData

	     */

	    setRealTimeData: function(pointData, redraw) {

	    	//if (pointData != null && pointData.length > 0) {

	    	if (pointData) {

	    		var len = this.getDataLength();

		        var last_data_time_utc = this.getLastDataTimeUtc();

		        var update_date = pointData[0];

		        var is_upd = false;

	        

		        if (pointData[6] == 2 || pointData[6] == 4 || pointData[6] == 1 || pointData[6] == 5) { // 일월분년

		        	is_upd = last_data_time_utc == update_date ? true : false; 

		        } else if (pointData[6] == 3) { // 3: 주봉

		        	var last_date = nexUtils.date2Utc(Highcharts.dateFormat('%Y%m%d', last_data_time_utc));

		        	var new_date = nexUtils.date2Utc(Highcharts.dateFormat('%Y%m%d', update_date));

		        	

		        	if( last_date <= new_date && new_date < last_date+(7*24*60*60*1000) ){

		        		is_upd = true;

		        	}

		        }    

		        

		        if (is_upd && len > 0) { // UPD

		        	if (this._data[len - 1][2] < pointData[2]) {

		        		this._data[len - 1][2] = pointData[2];

		        	}

		        	if (this._data[len - 1][3] > pointData[3]) {

		        		this._data[len - 1][3] = pointData[3];

		        	}

		        	this._data[len - 1][4] = pointData[4];

		        	this._data[len - 1][5] = this._data[len - 1][5] + pointData[5];

		

		        	this.updatePointData(len - 1, this._data[len - 1], true);

		        } else { // INS

		        	if (this._exceptIdx != 0) {

			            var last_time = null;

			            var add_time = null;

			            var add_date_utc_time = null;

			            var add_point_data = [];

		

			            // self._monthSect: 2: 일봉, 3: 주봉, 4: 월봉, 1: 분봉, 7: 시봉

			            if (pointData[6] == 2) { // 2: 일봉

			            	last_time = Highcharts.dateFormat('%Y%m%d', this._data[this._data.length - 1][0]);

			            	if (pointData[8].toString().substr(0, 8) != last_time) { // 일 변경 처리

			            		this.datePointChangeData(pointData[8].toString(), 'dd', 1); // 빈데이터 날짜 변경처리

			            	}             	  

			            	last_time = Highcharts.dateFormat('%Y%m%d', this._data[this._data.length - 1][0]);

			            	add_time = nexUtils.addDateFullTime(last_time, 'dd', 1);

			            } else if (pointData[6] == 3) { // 3: 주봉

			            	last_time = Highcharts.dateFormat('%Y%m%d', this._data[this._data.length - 1][0]);

			            	if (pointData[8].toString().substr(0, 8) != last_time) { // 일 변경 처리

			            		this.datePointChangeData(pointData[8].toString(), 'week', 1); // 빈데이터 날짜 변경처리

			            	}

			            	last_time = Highcharts.dateFormat('%Y%m%d', this._data[this._data.length - 1][0]);

			            	add_time = nexUtils.addDateFullTime(last_time, 'week', 1);

			            } else if (pointData[6] == 4) { // 4: 월봉

			            	last_time = Highcharts.dateFormat('%Y%m%d', this._data[this._data.length - 1][0]);

			            	if (pointData[8].toString().substr(0, 6) != last_time) { // 일 변경 처리

			            		this.datePointChangeData(pointData[8].toString(), 'mm', 1); // 빈데이터 날짜 변경처리

			            	}

			            	last_time = Highcharts.dateFormat('%Y%m%d', this._data[this._data.length - 1][0]);

			            	add_time = nexUtils.addDateFullTime(last_time, 'mm', 1);

			            } else if (pointData[6] == 1) { // 1: 분봉

			            	last_time = Highcharts.dateFormat('%Y%m%d%H%M', this._data[this._data.length - 1][0]);

			            	if (pointData[8].toString().substr(0, 8) != last_time.substr(0, 8)) { // 일 변경 처리

			            		this.datePointChangeData(pointData[8].toString(), 'MINUTE', 1); // 빈데이터 날짜 변경처리

			            	}

			            	last_time = Highcharts.dateFormat('%Y%m%d%H%M', this._data[this._data.length - 1][0]);

			            	add_time = nexChartUtils.getAddTime('MINUTE', last_time, Number(pointData[7]));

			            } else if (pointData[6] == 7) { // 7: 시봉

			            	last_time = Highcharts.dateFormat('%Y%m%d%H', this._data[this._data.length - 1][0]);

			            	if (pointData[8].toString().substr(0, 8) != last_time.substr(0, 8)) { // 일 변경 처리

			            		this.datePointChangeData(pointData[8].toString().substr(0, 10), 'HOURS', 1); // 빈데이터 날짜 변경처리

			            	}

			            	last_time = Highcharts.dateFormat('%Y%m%d%H', this._data[this._data.length - 1][0]);

			            	add_time = nexChartUtils.getAddTime('HOURS', last_time, Number(pointData[7]) / 60);

			            }

		            

			            add_date_utc_time = nexUtils.date2Utc(add_time);

		            

			            // 날짜 또는 시간,시가,고가,저가,종가,거래량

			            add_point_data.push(Number(add_date_utc_time), null, null, null, null, null, 'except');

		

			            this.addPointData(add_point_data);

		            

			            // 제외 idx 증가 및 전체 Len 증가

			            this._exceptIdx++;

			            this._dataLen++;

		            

			            //last_data_time_utc = this._data[this._exceptIdx - 1][0];

		

			            // UPD 후 신규데이터 추가

			            //if (pointData[0] == last_data_time_utc) {

		              	this._data[len][1] = pointData[1]; // 시가

		              	this._data[len][2] = pointData[2]; // 고가

		              	this._data[len][3] = pointData[3]; // 저가

		              	this._data[len][4] = pointData[4]; // 종가

		              	this._data[len][5] = pointData[5]; // 거래량

		              	this._data[len][6] = ''; // except 여부

		              

		              	this.updatePointData(len, this._data[len], true);

		              	if(redraw){
		              		this._chart.redraw();
		              	}

		              	//}

		        	} else {

		        		this._data.push([pointData[0], pointData[1], pointData[2], pointData[3], pointData[4], pointData[5]]);

		

		        		this.addPointData(pointData);

		        		this._dataLen++;

		        	}

		        }

		    }

	    },

	    /**

	     * desc : 일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

	     * date : 2015.07.22

	     * 

	     * @param datePoint

	     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

	     * @param unit

	     */

	    datePointChangeData: function(datePoint, interval, unit) {

	    	if (datePoint != null && datePoint != '') {

	    		this._data[this._exceptIdx][0] = nexUtils.date2Utc(datePoint); // 기본 Data 처리

	

	    		var up_cnt = 1;

	    		for(var i = this._exceptIdx, len = this._dataLen; i < len; i++) {

	    			if (interval == 'MINUTE' || interval == 'HOURS') {

	    				var add_time = nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt);

	    				this._data[i][6] = add_time;

	    				this._data[i][0] = nexUtils.date2Utc(add_time);

	    			} else {

	    				var add_time = nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt);

	    				this._data[i][6] = add_time;

	    				this._data[i][0] = nexUtils.date2Utc(add_time);

	    			}

	    			up_cnt++;

		        }

	

	    		for (var i = 0, len = this._seriesDataCnt; i < len; i++) {

	    			var data_type = this.getSeriesDataType(i);

	    			var series_id = this.getSeriesDataId(i);

	

	    			// 각 지표 Data 처리

	    			switch (data_type) {

	    			case 'candle':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id).update({ data: this._seriesData[i].getData() });

	    				break;

	    			case 'volume':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id).update({ data: this._seriesData[i].getData() });

	    				break;

	    			case 'sma':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id + '_1').update({ data: this._seriesData[i].getData(1) });

	    				this._chart.get(series_id + '_2').update({ data: this._seriesData[i].getData(2) });

	    				this._chart.get(series_id + '_3').update({ data: this._seriesData[i].getData(3) });

	    				this._chart.get(series_id + '_4').update({ data: this._seriesData[i].getData(4) });

	    				this._chart.get(series_id + '_5').update({ data: this._seriesData[i].getData(5) });

	    				break;

	    			case 'cna':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id + '_1').update({ data: this._seriesData[i].getData(1) });

	    				this._chart.get(series_id + '_2').update({ data: this._seriesData[i].getData(2) });

	    				this._chart.get(series_id + '_3').update({ data: this._seriesData[i].getData(3) });

	    				this._chart.get(series_id + '_4').update({ data: this._seriesData[i].getData(4) });

	    				this._chart.get(series_id + '_5').update({ data: this._seriesData[i].getData(5) });

	    				this._chart.get(series_id + '_6').update({ data: this._seriesData[i].getData(6) });

	    				this._chart.get(series_id + '_7').update({ data: this._seriesData[i].getData(7) });

	    				break;

	    			case 'bollinger':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id + '_1').update({ data: this._seriesData[i].getData(1) });

	    				this._chart.get(series_id + '_2').update({ data: this._seriesData[i].getData(2) });

	    				this._chart.get(series_id + '_3').update({ data: this._seriesData[i].getData(3) });

	    				break;

	    			case 'envelope':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id + '_1').update({ data: this._seriesData[i].getData(1) });

	    				this._chart.get(series_id + '_2').update({ data: this._seriesData[i].getData(2) });

	    				this._chart.get(series_id + '_3').update({ data: this._seriesData[i].getData(3) });

	    				break;

	    			case 'parabolic':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id).update({ data: this._seriesData[i].getData() });

	    				break;

	    			case 'maribbon':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				for (var j = 0; j < this._seriesData[i].getRcnt(); j++)

	    					this._chart.get(series_id + '_' + (j + 1)).update({ data: this._seriesData[i].getData(j) });

	    				break;

	    			case 'macd':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id + '_1').update({ data: this._seriesData[i].getData(1) });

	    				this._chart.get(series_id + '_2').update({ data: this._seriesData[i].getData(2) });

	    				this._chart.get(series_id + '_3').update({ data: this._seriesData[i].getData(3) });

	    				break;

	    			case 'slowstc':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id + '_1').update({ data: this._seriesData[i].getData(2) });

	    				this._chart.get(series_id + '_2').update({ data: this._seriesData[i].getData(3) });

	    				break;

	    			case 'faststc':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id + '_1').update({ data: this._seriesData[i].getData(1) });

	    				this._chart.get(series_id + '_2').update({ data: this._seriesData[i].getData(2) });

	    				break;

	    			case 'cci':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id + '_1').update({ data: this._seriesData[i].getData(3) });

	    				this._chart.get(series_id + '_2').update({ data: this._seriesData[i].getData(4) });

	    				break;

	    			case 'mental':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id + '_1').update({ data: this._seriesData[i].getData(1) });

	    				this._chart.get(series_id + '_2').update({ data: this._seriesData[i].getData(2) });

	    				break;

	    			case 'adx':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id + '_1').update({ data: this._seriesData[i].getData(1) });

	    				this._chart.get(series_id + '_2').update({ data: this._seriesData[i].getData(2) });

	    				this._chart.get(series_id + '_3').update({ data: this._seriesData[i].getData(3) });

	    				break;

	    			case 'obv':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id + '_1').update({ data: this._seriesData[i].getData(1) });

	    				this._chart.get(series_id + '_2').update({ data: this._seriesData[i].getData(2) });

	    				break;

	    			case 'sonar':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id + '_1').update({ data: this._seriesData[i].getData(1) });

	    				this._chart.get(series_id + '_2').update({ data: this._seriesData[i].getData(2) });

	    				break;

	    			case 'vr':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id).update({ data: this._seriesData[i].getData() });

	    				break;

	    			case 'trix':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id + '_1').update({ data: this._seriesData[i].getData(1) });

	    				this._chart.get(series_id + '_2').update({ data: this._seriesData[i].getData(2) });

	    				break;

	    			case 'williams':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id + '_1').update({ data: this._seriesData[i].getData(1) });

	    				this._chart.get(series_id + '_2').update({ data: this._seriesData[i].getData(2) });

	    				break;

	    			case 'roc':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id + '_1').update({ data: this._seriesData[i].getData(1) });

	    				this._chart.get(series_id + '_2').update({ data: this._seriesData[i].getData(2) });

	    				break;

	    			case 'rsi':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id + '_1').update({ data: this._seriesData[i].getData(1) });

	    				this._chart.get(series_id + '_2').update({ data: this._seriesData[i].getData(2) });

	    				break;

	    			case 'dis':

		            	this._seriesData[i].datePointChangeData(datePoint, interval, unit);

		            	this._chart.get(series_id + '_1').update({ data: this._seriesData[i].getData(1) });

	    				this._chart.get(series_id + '_2').update({ data: this._seriesData[i].getData(2) });

	    				this._chart.get(series_id + '_3').update({ data: this._seriesData[i].getData(3) });

	    				this._chart.get(series_id + '_4').update({ data: this._seriesData[i].getData(4) });

	    				break;

	    			case 'dmi':

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id + '_1').update({ data: this._seriesData[i].getData(1) });

	    				this._chart.get(series_id + '_2').update({ data: this._seriesData[i].getData(2) });

	    				break;

	    			default: // 캔들

	    				this._seriesData[i].datePointChangeData(datePoint, interval, unit);

	    				this._chart.get(series_id).update({ data: this._seriesData[i].getData() });

	    				break;

	    			}

	    		} // for

	    		this._chart.redraw();

	    	}

	    },

	    /**

	     * desc : 한건의 pointData 추가

	     * date : 2015.07.22

	     * 

	     * @param pointData

	     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) {

        this._data.push(pointData);



        for (var i = 0, len = this._seriesDataCnt; i < len; i++) {

          var data_type = this.getSeriesDataType(i);

          var series_id = this.getSeriesDataId(i);



          switch (data_type) {

            case 'candle':

              this._seriesData[i].addPointData(pointData);

              this._chart.get(series_id).addPoint(this._seriesData[i].getLastData(false).slice(), false, false, false);

              break;

            case 'volume':

              this._seriesData[i].addPointData(pointData);

              this._chart.get(series_id).addPoint(this._seriesData[i].getCloneLastData(false), false, false, false);

              break;

            case 'sma':

              var data_len = this._seriesData[i]._dataSmaNums.length;

              this._seriesData[i].addPointData(pointData);

              for(var j=0;j<data_len;j++){

            	  this._chart.get(series_id + '_' + (j+1)).addPoint(this._seriesData[i].getLastData(j+1, false).slice(), false, false, false);

              }

              break;

            case 'cna':

              this._seriesData[i].addPointData(this._data);

              this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getLastData(1, false).slice(), false, false, false);

              this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getLastData(2, false).slice(), false, false, false);

              this._chart.get(series_id + '_3').addPoint(this._seriesData[i].getLastData(3, false).slice(), false, false, false);

              this._chart.get(series_id + '_4').addPoint(this._seriesData[i].getLastData(4, false).slice(), false, false, false);

              this._chart.get(series_id + '_5').addPoint(this._seriesData[i].getLastData(5, false).slice(), false, false, false);

              this._chart.get(series_id + '_6').addPoint(this._seriesData[i].getLastData(6, false).slice(), false, false, false);

              this._chart.get(series_id + '_7').addPoint(this._seriesData[i].getLastData(7, false).slice(), false, false, false);

              break;

            case 'bollinger':

              this._seriesData[i].addPointData(pointData);

              this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getLastData(1, false).slice(), false, false, false);

              this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getLastData(2, false).slice(), false, false, false);

              this._chart.get(series_id + '_3').addPoint(this._seriesData[i].getLastData(3, false).slice(), false, false, false);

              break;

            case 'envelope':

              this._seriesData[i].addPointData(pointData);

              this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getLastData(1, false).slice(), false, false, false);

              this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getLastData(2, false).slice(), false, false, false);

              this._chart.get(series_id + '_3').addPoint(this._seriesData[i].getLastData(3, false).slice(), false, false, false);

              break;

            case 'parabolic':

              this._seriesData[i].addPointData(pointData);

              this._chart.get(series_id).addPoint(this._seriesData[i].getCloneLastData(false), false, false, false);

              break;

            case 'maribbon':

              this._seriesData[i].addPointData(pointData);

              for (var j = 0; j < this._seriesData[i].getRcnt(); j++) {

                this._chart.get(series_id + '_' + (j + 1)).addPoint(this._seriesData[i].getLastData(j, false).slice(), false, false, false);

              }

              break;

            case 'macd':

              this._seriesData[i].addPointData(pointData);

              this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getCloneLastData(1, false), false, false, false);

              this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getCloneLastData(2, false), false, false, false);

              this._chart.get(series_id + '_3').addPoint(this._seriesData[i].getCloneLastData(3, false), false, false, false);

              break;

            case 'slowstc':

              this._seriesData[i].addPointData(pointData);

              this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getLastData(2, false).slice(), false, false, false);

              this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getLastData(3, false).slice(), false, false, false);

              break;

            case 'faststc':

            	this._seriesData[i].addPointData(pointData);

            	this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getLastData(1, false).slice(), false, false, false);

            	this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getLastData(2, false).slice(), false, false, false);

            	break;

            case 'cci':

              this._seriesData[i].addPointData(pointData);

              this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getLastData(3, false).slice(), false, false, false);

              this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getLastData(4, false).slice(), false, false, false);

              break;

            case 'mental':

              this._seriesData[i].addPointData(pointData);

              this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getLastData(1, false).slice(), false, false, false);

              this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getLastData(2, false).slice(), false, false, false);

              break;

            case 'adx':

              this._seriesData[i].addPointData(pointData);

              this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getLastData(1, false).slice(), false, false, false);

              this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getLastData(2, false).slice(), false, false, false);

              this._chart.get(series_id + '_3').addPoint(this._seriesData[i].getLastData(3, false).slice(), false, false, false);

              break;

            case 'obv':

              this._seriesData[i].addPointData(pointData);

              this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getLastData(1, false).slice(), false, false, false);

              this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getLastData(2, false).slice(), false, false, false);

              break;

            case 'sonar':

              this._seriesData[i].addPointData(pointData);

              this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getLastData(1, false).slice(), false, false, false);

              this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getLastData(2, false).slice(), false, false, false);

              break;

            case 'vr':

              this._seriesData[i].addPointData(pointData);

              this._chart.get(series_id).addPoint(this._seriesData[i].getLastData(false).slice(), false, false, false);

              break;

            case 'trix':

              this._seriesData[i].addPointData(pointData);

              this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getLastData(1, false), false, false, false);

              this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getLastData(2, false), false, false, false);

              break;

            case 'williams':

              this._seriesData[i].addPointData(pointData);

              this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getLastData(1, false).slice(), false, false, false);

              this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getLastData(2, false).slice(), false, false, false);

              break;

            case 'roc':

              this._seriesData[i].addPointData(pointData);

              this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getLastData(1, false).slice(), false, false, false);

              this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getLastData(2, false).slice(), false, false, false);

              break;

            case 'rsi':

            	this._seriesData[i].addPointData(pointData);

            	this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getLastData(1, false).slice(), false, false, false);

            	this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getLastData(2, false).slice(), false, false, false);

            	break;

            case 'dis':

            	this._seriesData[i].addPointData(pointData);

            	this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getLastData(1, false).slice(), false, false, false);

            	this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getLastData(2, false).slice(), false, false, false);

            	this._chart.get(series_id + '_3').addPoint(this._seriesData[i].getLastData(3, false).slice(), false, false, false);

            	this._chart.get(series_id + '_4').addPoint(this._seriesData[i].getLastData(4, false).slice(), false, false, false);

            	break;

            case 'dmi':

            	this._seriesData[i].addPointData(pointData);

            	this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getLastData(1, false).slice(), false, false, false);

            	this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getLastData(2, false).slice(), false, false, false);

            	break;

            default: // 캔들

              this._seriesData[i].addPointData(pointData);

              this._chart.get(series_id).addPoint(this._seriesData[i].getLastData(false).slice(), false, false, false);

              break;

          }

        }

        this._chart.redraw();

      }

    },

    /**

     * desc : 데이터 업데이트

     * date : 2015.07.22

     * 

     * @param point : 업데이트할 위치(index)

     * @param pointData : 업데이트할 데이터

     * @param exceptFlag

     */

    updatePointData: function(point, pointData, exceptFlag) {

      if (point != null && pointData != null && pointData.length > 0) {

        if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

          exceptFlag = false;

        }

        for (var i = 0, len = this._seriesDataCnt; i < len; i++) {

          var data_type = this.getSeriesDataType(i);

          var series_id = this.getSeriesDataId(i);

          var upd_idx = point;

          switch (data_type) {

            case 'candle': //(완료)

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx() - 1;

              this._seriesData[i].updatePointData(upd_idx, pointData);

              this._chart.get(series_id).data[upd_idx].update(this._seriesData[i].getLastData().slice(), false, false, false);

              break;

            case 'volume': // (완료)

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx() - 1;

              this._seriesData[i].updatePointData(upd_idx, pointData);

              this._chart.get(series_id).data[upd_idx].update(this._seriesData[i].getCloneLastData(), false, false, false);

              break;

            case 'sma': // (완료)

              var data_len = this._seriesData[i]._dataSmaNums.length;

              this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx() - 1;

              

              for(var j=0;j<data_len;j++){

            	  this._chart.get(series_id + '_' + (j+1)).data[upd_idx].update(this._seriesData[i].getLastData(j+1).slice(), false, false, false);

              }

              

              break;

            case 'cna':

              this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(1) - 1;

              this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(1).slice(), false, false, false);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(2) - 1;

              this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(2).slice(), false, false, false);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(3) - 1;

              this._chart.get(series_id + '_3').data[upd_idx].update(this._seriesData[i].getLastData(3).slice(), false, false, false);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(4) - 1;

              this._chart.get(series_id + '_4').data[upd_idx].update(this._seriesData[i].getLastData(4).slice(), false, false, false);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(5) - 1;

              this._chart.get(series_id + '_5').data[upd_idx].update(this._seriesData[i].getLastData(5).slice(), false, false, false);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(6) - 1;

              this._chart.get(series_id + '_6').data[upd_idx].update(this._seriesData[i].getLastData(6).slice(), false, false, false);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(7) - 1;

              this._chart.get(series_id + '_7').data[upd_idx].update(this._seriesData[i].getLastData(7).slice(), false, false, false);

              break;

            case 'bollinger': // (완료)

              this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx() - 1;

              this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(1).slice(), false, false, false);

              this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(2).slice(), false, false, false);

              this._chart.get(series_id + '_3').data[upd_idx].update(this._seriesData[i].getLastData(3).slice(), false, false, false);

              break;

            case 'envelope': // (완료)

              this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx() - 1;

              this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(1).slice(), false, false, false);

              this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(2).slice(), false, false, false);

              this._chart.get(series_id + '_3').data[upd_idx].update(this._seriesData[i].getLastData(3).slice(), false, false, false);

              break;

            case 'parabolic':

                if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx() - 1;

                this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

                this._chart.get(series_id).data[upd_idx].update(this._seriesData[i].getCloneLastData(), false, false, false);

                break;

            case 'maribbon': // (완료)

              this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

              for (var j = 0; j < this._seriesData[i].getRcnt(); j++) {

                if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(j) - 1;

                this._chart.get(series_id + '_' + (j + 1)).data[upd_idx].update(this._seriesData[i].getLastData(j).slice(), false, false, false);

              }

              break;

            case 'macd': // (수정완료, 확인필요)

              this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(1) - 1;

              this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(1), false, false, false);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(2) - 1;

              this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(2), false, false, false);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(3) - 1;

              this._chart.get(series_id + '_3').data[upd_idx].update(this._seriesData[i].getLastData(3), false, false, false);

              break;

            case 'slowstc': // (완료)

              this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(2) - 1;

              this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(2).slice(), false, false, false);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(3) - 1;

              this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(3).slice(), false, false, false);

              break;

            case 'faststc': // (완료)

            	this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

            	if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(1) - 1;

            	this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(1).slice(), false, false, false);

            	if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(2) - 1;

            	this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(2).slice(), false, false, false);

            	break;

            case 'cci': // (완료)

              this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(3) - 1;

              this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(3).slice(), false, false, false);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(4) - 1;

              this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(4).slice(), false, false, false);

              break;

            case 'mental': // (완료)

              this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(1) - 1;

              this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(1).slice(), false, false, false);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(2) - 1;

              this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(2).slice(), false, false, false);

              break;

            case 'adx': // (수정완료, 확인필요)

              this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(1) - 1;

              this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(1).slice(), false, false, false);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(2) - 1;

              this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(2).slice(), false, false, false);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(3) - 1;

              this._chart.get(series_id + '_3').data[upd_idx].update(this._seriesData[i].getLastData(3).slice(), false, false, false);

              break;

            case 'obv': // (완료)

              this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(1) - 1;

              this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(1).slice(), false, false, false);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(2) - 1;

              this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(2).slice(), false, false, false);

              break;

            case 'sonar': // (완료)

              this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(1) - 1;

              this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(1), false, false, false);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(2) - 1;

              this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(2), false, false, false);

              break;

            case 'vr': // (완료)

              this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx() - 1;

              this._chart.get(series_id).data[upd_idx].update(this._seriesData[i].getLastData().slice(), false, false, false);

              break;

            case 'trix': // (완료)

              this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(1) - 1;

              this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(1), false, false, false);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(2) - 1;

              this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(2), false, false, false);

              break;

            case 'williams': // (완료)

              this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(1) - 1;

              this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(1).slice(), false, false, false);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(2) - 1;

              this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(2).slice(), false, false, false);

              break;

            case 'roc': // (완료)

              this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(1) - 1;

              this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(1).slice(), false, false, false);

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(2) - 1;

              this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(2).slice(), false, false, false);

              break;

            case 'rsi':

            	this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

            	if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(1) - 1;

            	this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(1).slice(), false, false, false);

            	if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(2) - 1;

            	this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(2).slice(), false, false, false);

            	break;

            case 'dis':

            	this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

            	if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(1) - 1;

            	this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(1).slice(), false, false, false);

            	if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(2) - 1;

            	this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(2).slice(), false, false, false);

            	if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(3) - 1;

            	this._chart.get(series_id + '_3').data[upd_idx].update(this._seriesData[i].getLastData(3).slice(), false, false, false);

            	if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(4) - 1;

            	this._chart.get(series_id + '_4').data[upd_idx].update(this._seriesData[i].getLastData(4).slice(), false, false, false);

            	break;

            case 'dmi':

            	this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);

            	if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(1) - 1;

            	this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(1).slice(), false, false, false);

            	if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(2) - 1;

            	this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(2).slice(), false, false, false);

            	break;

            default: // 캔들

              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx() - 1;

              this._seriesData[i].updatePointData(upd_idx, pointData);

              this._chart.get(series_id).data[upd_idx].update(this._seriesData[i].getLastData().slice(), false, false, false);

              break;

          }

        }

      }

    },

    /**

     * desc : 차트 갱신(새로 그리기)

     * date : 2015.07.22

     * 

     */

    redraw: function() {

      this._chart.redraw();

    },

    /**

     * desc : 시리즈데이터 오브젝트 제거

     * date : 2015.07.22

     * 

     */

    destroy: function() {

      delete this._seriesData;

      this._seriesData = null;

    },

    removeAllSeries: function() {

    	var series_length = this._chart.get().series.length;

    	for(var i=0;i<series_length;i++){

    		this._chart.get().series[i].setData([0,0],false,false,false);

    	}

    }

  };



  /**

   * desc : 캔들스틱 데이터 객체(candle)

   * date : 2015.07.22

   * 

   */

  var candleData = function(chart, seqId, chartData) {

	this._chart = chart;	  

    this._type = 'candle';

    this._id = seqId;

    this._data = [];

    this._exceptIdx = 0;



    this.init();

    this.setData(chartData);

  }

  candleData.prototype = {

    init: function() {

      this._exceptIdx = 0;

    },

    /**

     * desc : get this._type

     * date : 2015.07.22

     * 

     * @return {String}

     */

    getType: function() {

      return this._type;

    },

    /**

     * desc: id 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getId: function() {

      return this._id;

    },

    /**

     * desc : 초기 전체 데이터 가공

     * date : 2015.07.22

     *

     * @param chartData : 차트 데이터

     */

    setData: function(chartData) {

      if (chartData != null && chartData.length > 0) {

        for (var i = 0, len = chartData.length; i < len; i++) {

          // 빈데이터(현재일 + 26일) 있을 경우 빈데이터 제외하고 데이터 처리

          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

        	   // data_time, data_open, dataUp, dataDown, data_close  

            this._data.push([Number(chartData[i][0]), Number(chartData[i][1]), Number(chartData[i][2]), Number(chartData[i][3]), Number(chartData[i][4])]);

            this._exceptIdx++;

          } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

            this._data.push([Number(chartData[i][0]), null, null, null, null]);

          }

        }

      }

    },

    /**

     * desc : 일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2015.07.22

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      this._data[this._exceptIdx][0] = nexUtils.date2Utc(datePoint);

      for (var i = this._exceptIdx + 1, len = this._data.length, up_cnt = 1; i < len; i++, up_cnt++) {

        if (interval == 'MINUTE' || interval == 'HOURS') {

          this._data[i][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

        } else {

          this._data[i][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

        }

      }

    },

    /**

     * desc : 한건의 데이터 추가

     * date : 2015.07.22

     * 

     * @param pointData : 한건의 데이터

     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) {

        var arr_data = [];

        arr_data.push(pointData[0], pointData[1], pointData[2], pointData[3], pointData[4]);

        this._data.push(arr_data);

        this._exceptIdx++;

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2015.07.22

     * 

     * @param point : 업데이트될 위치(index)

     * @param pointData : 한건의 데이터

     */

    updatePointData: function(point, pointData) {

      if (pointData != null && pointData.length > 0) {

        var arr_data = [];

        arr_data.push(pointData[0], pointData[1], pointData[2], pointData[3], pointData[4]);

        this._data[point] = arr_data;

      }

    },

    /**

     * desc : 전체 데이터 반환

     * date : 2015.07.22

     * 

     * @return {Array}

     */

    getData: function() {

      return this._data;

    },

    /**

     * desc : index 위치의 데이터 반환

     * date : 2015.07.22

     * 

     * @param index : 위치

     * @return {Object}

     */

    getIndexData: function(index) {

      return this._data[index];

    },

    /**

     * desc : 마지막 데이터 반환

     * date : 2015.07.22

     * 

     * @param exceptflag : 빈데이터 제외 flag(true: 제외, false: 포함, default: true)

     * @return

     */

    getLastData: function(exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }

      var last_len = this._data.length - 1;

      // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

      if (exceptFlag && this._exceptIdx != 0) {

        last_len = this._exceptIdx - 1;

      }

      return this._data[last_len];

    },

    /**

     * desc : 빈데이터 시작 IDX 반환

     * date : 2015.07.22

     * 

     * @return {Number}

     */

    getExceptIdx: function() {

      return this._exceptIdx;

    }

  };



  /**

   * desc : 거래량 데이터 객체(volume)

   * date : 2015.07.22

   * 

   */

  var volumeData = function(chart, seqId, chartData) {

	 this._chart = chart;

    this._type = 'volume';

    this._id = seqId;

    this._data = [];

    this._exceptIdx = 0;



    this.init();

    this.setData(chartData);

  }

  volumeData.prototype = {

    init: function() {

      this._exceptIdx = 0;

    },

    /**

     * desc : 타입 리턴

     * date : 2015.07.22

     * 

     * @return {String}

     */

    getType: function() {

      return this._type;

    },

    /**

     * desc: id 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getId: function() {

      return this._id;

    },

    /**

     * desc : 초기 전체 데이터 가공

     * date : 2015.07.22

     * 

     * @param chartData : 차트 데이터

     */

    setData: function(chartData) {

      for (var i = 0, len = chartData.length; i < len; i++) {

        var data_time 	= chartData[i][0];

        var data_open 	= chartData[i][1];

        var data_close 	= chartData[i][4];

        var data_volume = chartData[i][5];

        var last_data_volume = 0;

        if(i!=0) last_data_volume = chartData[i-1][5];

        

        var volume_color = Highcharts.getOptions().colors[1];

        if (Number(data_volume) > Number(last_data_volume)) {

          volume_color = Highcharts.getOptions().colors[0]

        } else if (Number(data_volume) == Number(last_data_volume)) {

          volume_color = "#000000";

        }

/*        if (Number(data_open) > Number(data_close)) {

        	volume_color = Highcharts.getOptions().colors[1]

        } else if (Number(data_open) == Number(data_close)) {

        	volume_color = "#000000";

        }

*/

        // 빈데이터(현재일 + 26일) 있을 경우 빈데이터 제외하고 데이터 처리

        if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

          this._data.push({

            color: volume_color,

            x: Number(data_time),

            y: Number(data_volume)

          });

          this._exceptIdx++;

        } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

          this._data.push({

            color: volume_color,

            x: Number(data_time),

            y: null

          });

        }

      }

    },

    /**

     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2015.07.22

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      this._data[this._exceptIdx][0] = nexUtils.date2Utc(datePoint);

      for (var i = this._exceptIdx + 1, len = this._data.length, up_cnt = 1; i < len; i++, up_cnt++) {

        if (interval == 'MINUTE' || interval == 'HOURS') {

          this._data[i]['x'] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

        } else {

          this._data[i]['x'] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

        }

      }

    },

    /**

     * desc : 한건의 데이터 추가

     * date : 2015.07.22

     * 

     * @param pointData : 한건의 데이터

     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) {

        var obj_data = {};

        var volume_color = Highcharts.getOptions().colors[0];



        if (Number(pointData[1]) > Number(pointData[4])) {

          volume_color = Highcharts.getOptions().colors[1];

        } else if (Number(pointData[1]) == Number(pointData[4])) {

          volume_color = "#000000";

        }



        obj_data = {

          color: volume_color,

          x: pointData[0],

          y: pointData[5]

        };



        this._data.push(obj_data);

        this._exceptIdx++;

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2015.07.22

     * 

     * @param point : 업데이트될 위치(index)

     * @param pointData : 한건의 데이터

     */

    updatePointData: function(point, pointData) {

      if (pointData != null && pointData.length > 0) {

        var obj_data = {};

        var volume_color = Highcharts.getOptions().colors[0];

        

        

        var exceptIdx = this.getExceptIdx();

        var last_data_volume = this._data[exceptIdx-2].y;

        

        var volume_color = Highcharts.getOptions().colors[1];

        if (Number(pointData[5]) > Number(last_data_volume)) {

        	volume_color = Highcharts.getOptions().colors[0]

        } else if (Number(pointData[5]) == Number(last_data_volume)) {

          volume_color = "#000000";

        }

/*

        if (Number(pointData[1]) > Number(pointData[4])) {

          volume_color = Highcharts.getOptions().colors[1];

        } else if (Number(pointData[1]) == Number(pointData[4])) {

          volume_color = "#000000";

        }

*/

        obj_data = {

          color: volume_color,

          x: pointData[0],

          y: pointData[5]

        };



        this._data[point] = obj_data;

      }

    },

    /**

     * desc : 전체 데이터 반환

     * date : 2015.07.22

     * 

     * @return {Array}

     */

    getData: function() {

      return this._data;

    },

    /**

     * desc : index 위치의 데이터 반환

     * date : 2015.07.22

     * 

     * @param index : 위치

     * @return {Object}

     */

    getIndexData: function(index) {

      return this._data[index];

    },

    /**

     * desc : index 위치의 데이터를 복사 후 반환

     * date : 2015.07.22

     * 

     * @param index : 위치

     * @return {Object}

     */

    getCloneIndexData: function(index) {

      return {

        color: this._data[index].color,

        x: this._data[index].x,

        y: this._data[index].y

      };

    },

    /**

     * desc : 마지막 데이터를 복사 후 반환

     * date : 2015.07.22

     * 

     * @param exceptflag : 빈데이터 제외 flag(true: 제외, false: 포함, default: true)

     * @return

     */

    getCloneLastData: function(exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }

      var last_len = this._data.length - 1;

      // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

      if (exceptFlag && this._exceptIdx != 0) {

        last_len = this._exceptIdx - 1;

      }

      return {

        color: this._data[last_len].color,

        x: this._data[last_len].x,

        y: this._data[last_len].y

      };

    },

    /**

     * desc : 빈데이터 시작 IDX 반환

     * date : 2015.07.22

     * 

     * @return {Number}

     */

    getExceptIdx: function() {

      return this._exceptIdx;

    }

  };



  /**

   * desc : 이동평균 데이터 객체(sma)

   * date : 2015.07.22

   * 

   */

  var smaData = function(chart, seqId, chartData, smaNums) {

	this._chart = chart;

    this._type = 'sma';

    this._id = seqId;

    this._data1 = [];

    this._data2 = [];

    this._data3 = [];

    this._data4 = [];

    this._data5 = [];

    this._dataSmaNums = smaNums;



    this._exceptIdx = 0;



    this.init();

    this.setData(chartData);

  }

  smaData.prototype = {

    init: function() {

      this._exceptIdx = 0;

    },

    /**

     * desc : 타입 리턴

     * date : 2015.07.22

     * 

     * @return {String}

     */

    //

    getType: function() {

      return this._type;

    },

    /**

     * desc: id 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getId: function() {

      return this._id;

    },

    /**

     * desc: 이동평균 기간 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getSmaNums: function() {

      return this._dataSmaNums;

    },

    /**

     * desc : 초기 전체 데이터 가공

     * date : 2015.07.22

     * 

     *

     * @param chartData : 차트 데이터

     */

    setData: function(chartData) {

      if (chartData != null && chartData.length > 0) {

        var data_sum1 = 0;

        var data_sum2 = 0;

        var data_sum3 = 0;

        var data_sum4 = 0;

        var data_sum5 = 0;



        for (var i = 0, len = chartData.length; i < len; i++) {

          // 빈데이터(현재일 + 26일) 있을 경우 빈데이터 제외하고 데이터 처리

          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

            if (i >= this._dataSmaNums[0] - 1) { // 5 이평

              data_sum1 += chartData[i][4];

              if (i - (this._dataSmaNums[0] - 1) > 0) {

                data_sum1 -= chartData[i - this._dataSmaNums[0]][4];

              }

              this._data1.push([Number(chartData[i][0]), Number((data_sum1 / this._dataSmaNums[0]).toFixed(2))]);

            } else {

              data_sum1 += chartData[i][4];

              this._data1.push([Number(chartData[i][0]), null]);

            }



            if (i >= this._dataSmaNums[1] - 1) { // 20 이평

              data_sum2 += chartData[i][4];

              if (i - (this._dataSmaNums[1] - 1) > 0) {

                data_sum2 -= chartData[i - this._dataSmaNums[1]][4];

              }

              this._data2.push([Number(chartData[i][0]), Number((data_sum2 / this._dataSmaNums[1]).toFixed(2))]);

            } else {

              data_sum2 += chartData[i][4];

              this._data2.push([Number(chartData[i][0]), null]);

            }



            if (i >= this._dataSmaNums[2] - 1) { // 60 이평

              data_sum3 += chartData[i][4];

              if (i - (this._dataSmaNums[2] - 1) > 0) {

                data_sum3 -= chartData[i - this._dataSmaNums[2]][4];

              }

              this._data3.push([Number(chartData[i][0]), Number((data_sum3 / this._dataSmaNums[2]).toFixed(2))]);

            } else {

              data_sum3 += chartData[i][4];

              this._data3.push([Number(chartData[i][0]), null]);

            }



            if (i >= this._dataSmaNums[3] - 1) { // 120 이평

              data_sum4 += Number(chartData[i][4]);

              if (i - (this._dataSmaNums[3] - 1) > 0) {

                data_sum4 -= chartData[i - this._dataSmaNums[3]][4];

              }

              this._data4.push([Number(chartData[i][0]), Number((data_sum4 / this._dataSmaNums[3]).toFixed(2))]);

            } else {

              data_sum4 += Number(chartData[i][4]);

              this._data4.push([Number(chartData[i][0]), null]);

            }

            

            if (i >= this._dataSmaNums[4] - 1) { // 200 이평

            	data_sum5 += Number(chartData[i][4]);

            	if (i - (this._dataSmaNums[4] - 1) > 0) {

            		data_sum5 -= chartData[i - this._dataSmaNums[4]][4];

            	}

            	this._data5.push([Number(chartData[i][0]), Number((data_sum5 / this._dataSmaNums[4]).toFixed(2))]);

            } else {

            	data_sum5 += Number(chartData[i][4]);

            	this._data5.push([Number(chartData[i][0]), null]);

            }

            this._exceptIdx++;



          } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

            this._data1.push([Number(chartData[i][0]), null]);

            this._data2.push([Number(chartData[i][0]), null]);

            this._data3.push([Number(chartData[i][0]), null]);

            this._data4.push([Number(chartData[i][0]), null]);

            this._data5.push([Number(chartData[i][0]), null]);

          }

          /*

          console.log(i + "//" + chartData[i][6] + "//" + chartData[i][1] + "//" + chartData[i][2] + "//" + chartData[i][3] + "//" + chartData[i][4] + "//"

          + dataSum1 + "//" + dataSum2 + "//" + data_sum3 + "//" + data_sum4 );

          */

        }

      }

    },

    /**

     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2015.07.22

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      var data_arr = [this._data1, this._data2, this._data3, this._data4, this._data5];

      for (var i = 0; i < data_arr.length; i++) {

        var data = data_arr[i];

        data[this._exceptIdx+1][0] = nexUtils.date2Utc(datePoint);



        for (var j = this._exceptIdx+1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {

          if (interval == 'MINUTE' || interval == 'HOURS') {

            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

          } else {

            data[j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

          }

        }

      }

    },

    /**

     * desc : 한건의 데이터 추가

     * date : 2015.07.22

     * 

     * @param pointData : 한건의 데이터

     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) { // 빈데이터 추가

        this._data1.push([Number(pointData[0]), null]);

        this._data2.push([Number(pointData[0]), null]);

        this._data3.push([Number(pointData[0]), null]);

        this._data4.push([Number(pointData[0]), null]);

        this._data5.push([Number(pointData[0]), null]);

        this._exceptIdx++;

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2015.07.22

     * 

     * @param point : 업데이트될 위치(index)

     * @param chartData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     */

    updatePointData: function(point, chartData, exceptFlag) {

      if (chartData != null && chartData.length > 0) {

        if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

          exceptFlag = false;

        }

        var data_sum1 = 0;

        var data_sum2 = 0;

        var data_sum3 = 0;

        var data_sum4 = 0;

        var data_sum5 = 0;

        var date_utc_time = chartData[point][0];



        if (point + 1 >= this._dataSmaNums[0]) {

          for (var i = 0; i < this._dataSmaNums[0]; i++) {

            data_sum1 += chartData[point - i][4];

          }

          this._data1[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), Number((data_sum1 / this._dataSmaNums[0]).toFixed(2))];

        } else {

          this._data1[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), null];

        }



        if (point + 1 >= this._dataSmaNums[1]) {

          for (var i = 0; i < this._dataSmaNums[1]; i++) {

            data_sum2 += chartData[point - i][4];

          }

          this._data2[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), Number((data_sum2 / this._dataSmaNums[1]).toFixed(2))];

        } else {

          this._data2[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), null];

        }



        if (point + 1 >= this._dataSmaNums[2]) {

          for (var i = 0; i < this._dataSmaNums[2]; i++) {

            data_sum3 += chartData[point - i][4];

          }

          this._data3[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), Number((data_sum3 / this._dataSmaNums[2]).toFixed(2))];

        } else {

          this._data3[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), null];

        }



        if (point + 1 >= this._dataSmaNums[3]) {

          for (var i = 0; i < this._dataSmaNums[3]; i++) {

            data_sum4 += chartData[point - i][4];

          }

          this._data4[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), Number((data_sum4 / this._dataSmaNums[3]).toFixed(2))];

        } else {

          this._data4[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), null];

        }

        

        if (point + 1 >= this._dataSmaNums[4]) {

        	for (var i = 0; i < this._dataSmaNums[4]; i++) {

        		data_sum5 += chartData[point - i][4];

        	}

        	this._data5[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), Number((data_sum5 / this._dataSmaNums[4]).toFixed(2))];

        } else {

        	this._data5[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), null];

        }

      }

    },

    /**

     * 차트별 전체 데이터 리턴

     * @param dataNum

     * @return {Array}

     */

    getData: function(dataNum) {

      var data = [];

      if (dataNum == 1) {

        data = this._data1;

      } else if (dataNum == 2) {

        data = this._data2;

      } else if (dataNum == 3) {

        data = this._data3;

      } else if (dataNum == 4) {

        data = this._data4;

      } else if (dataNum == 5) {

    	data = this._data5;

      }

      return data;

    },

    /**

     * 차트별 index 위치의 데이터 리턴.

     * @param dataNum

     * @param index

     * @return

     */

    getIndexData: function(dataNum, index) {

      var data = this.getData(dataNum);

      return data[index];

    },

    /**

     * 차트별 마지막 데이터 리턴

     * @param dataNum

     * @param exceptFlag: 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     * @return

     */

    getLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }

      var data = this.getData(dataNum);

      var last_len = data.length - 1;

      // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

      if (exceptFlag && this._exceptIdx != 0) {

        last_len = this._exceptIdx - 1;

      }

      return data[last_len];

    },

    /**

     * desc : 빈데이터 시작 IDX 반환

     * date : 2015.07.22

     * 

     * @return {Number}

     */

    getExceptIdx: function() {

      return this._exceptIdx;

    }

  };



  /**

   * desc : 일목균형 데이터 객체(cna)

   * date : 2015.07.22

   * 

   */

  var cnaData = function(chart, seqId, chartData, smaNums) {

	 this._chart = chart;

	 this._type = 'cna';

    this._id = seqId;

    this._data1 = []; //기준선

    this._data2 = []; //전환선

    this._data3 = []; //후행스팬

    this._data4 = []; //단기선행스팬

    this._data5 = []; //장기선행스팬 - 단기선행스팬 (구릅대)

    this._data6 = []; //단기선행스팬 - 장기선행스팬 (구름대)

    this._data7 = []; //장기선행스팬

    this._dataCnaNums = smaNums;



    this._pExceptIdx = 0; // 기본 데이터 제외 idx(except)

    this._exceptIdx = []; // 각 차트 제외 idx(except)



    this.arr_dataSum1 = [];

    this.arr_dataSum2 = [];

    this.arr_datesHightPrice3 = [];

    this.arr_datesLowPrice3 = [];



    this.init();

    this.setData(chartData);

  }

  cnaData.prototype = {

    init: function() {

      for (var i = 0; i < 7; i++) {

        this._exceptIdx[i] = 0;

      }



      this._pExceptIdx = 0;

      this.arr_dataSum1 = [];

      this.arr_dataSum2 = [];

      this.arr_datesHightPrice3 = [];

      this.arr_datesLowPrice3 = [];

    },

    /**

     * desc : 타입 리턴

     * date : 2015.07.22

     * 

     * @return {String}

     */

    getType: function() {

      return this._type;

    },

    /**

     * desc: id 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getId: function() {

      return this._id;

    },

    /**

     * 일목균형 기간 리턴

     * @return

     */

    getCnaNums: function() {

      return this._dataCnaNums;

    },

    /**

     * desc : 초기 전체 데이터 가공

     * date : 2015.07.22

     * 

     *

     * 일목균형 계산식

     * 기준선 = (최근 26일간의 최고치 + 최저치) / 2

     * 전환선 = (최근 9일간의 최고치 + 최저치) / 2

     * 후행스팬 = 그날의 종가를 26일 후행시킨선

     * 단기선행스팬 = (기준선 + 전환선) / 2를 26일 선행(앞으로) 시킨선

     * 장기선행스팬 = (최근 52일간의 최고치 + 최저치) / 2 를 26일 선행(앞으로)시킨선

     *

     * @param chartData : 차트 데이터

     */

    setData: function(chartData) {

      if (chartData != null && chartData.length > 0) {

        for (var i = 0, len = chartData.length; i < len; i++) {

          // 빈데이터(현재일 + 26일) 있을 경우 빈데이터 제외하고 데이터 처리

          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

            // 기준선(26) = (최근 26일간의 최고치 + 최저치) / 2 (i >= 25 일때 부터)

            if (i >= Number(this._dataCnaNums[0]) - 1) {

              var dates_high_price1 = nexChartUtils.getHighMax(i, this._dataCnaNums[0], chartData);

              var dates_low_price1 = nexChartUtils.getLowMin(i, this._dataCnaNums[0], chartData);



              this.arr_dataSum1[i] = [(dates_high_price1 + dates_low_price1) / 2, chartData[i][0]];



              this._data1.push([Number(chartData[i][0]), Number(this.arr_dataSum1[i][0])]);

              this._exceptIdx[0]++;

            } else {

              this.arr_dataSum1[i] = [null, chartData[i][0]];

            }

            // 전환선(9) = (최근 9일간의 최고치 + 최저치) / 2 (i >= 8 일때 부터)

            if (i >= Number(this._dataCnaNums[1]) - 1) {

              var dates_high_price2 = nexChartUtils.getHighMax(i, this._dataCnaNums[1], chartData);

              var dates_low_price2 = nexChartUtils.getLowMin(i, this._dataCnaNums[1], chartData);



              this.arr_dataSum2[i] = [(dates_high_price2 + dates_low_price2) / 2, chartData[i][0]];



              this._data2.push([Number(chartData[i][0]), Number(this.arr_dataSum2[i][0])]);

              this._exceptIdx[1]++;

            } else {

              this.arr_dataSum2[i] = [null, chartData[i][0]];

            }

            // 후행스팬(26) 그날의 종가를 26일 후행시킨선

            if (i <= chartData.length - Number(this._dataCnaNums[2])) {

              var data_sum3 = chartData[i + (Number(this._dataCnaNums[2]) - 1)][4];



              if (data_sum3 != null) {

                this._data3.push([Number(chartData[i][0]), Number(data_sum3) == 0 ? null : Number(data_sum3)]);

                this._exceptIdx[2]++;

              } else {

                this._data3.push([Number(chartData[i][0]), null]);

              }

            }

            this._pExceptIdx++;



          } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

            this._data1.push([Number(chartData[i][0]), null]);

            this._data2.push([Number(chartData[i][0]), null]);

            this._data3.push([Number(chartData[i][0]), null]);

          }

          

          // 단기선행스팬(26) = (기준선 + 전환선) / 2를 26일 선행시킨선 (i >= 50일때 부터)

          var data_sum4 = null;

          if (i >= (Number(this._dataCnaNums[0]) + Number(this._dataCnaNums[3]) - 2)) {

            data_sum4 = (this.arr_dataSum1[i - Number(this._dataCnaNums[3]) + 1][0] + this.arr_dataSum2[i - Number(this._dataCnaNums[3]) + 1][0]) / 2;



            this._data4.push([Number(chartData[i][0]), Number(data_sum4)]);

            this._exceptIdx[3]++;

            //console.log(chartData[i][6] + "//i=" + i + "//data_sum4=" + data_sum4);

          }

          

          // 장기선행스팬(52) = (최근 52일간의 최고치 + 최저치) / 2 를 26일 선행(앞으로)시킨선 (i >= 76일때 부터)

          var data_sum5 = null;

          if (i >= (Number(this._dataCnaNums[4]) - 1)) { // (i >= 51일때 부터)

            var dates_high_price3 = nexChartUtils.getHighMax(i, this._dataCnaNums[4], chartData); // 52일 최고

            var dates_low_price3 = nexChartUtils.getLowMin(i, this._dataCnaNums[4], chartData); // 52일 최저



            this.arr_datesHightPrice3[i] = [dates_high_price3, chartData[i][0]];

            this.arr_datesLowPrice3[i] = [dates_low_price3, chartData[i][0]];



            if (i >= Number(this._dataCnaNums[4]) + Number(this._dataCnaNums[3]) - 2) { // (i >= 76일때부터)

              data_sum5 = (this.arr_datesHightPrice3[i - Number(this._dataCnaNums[3]) + 1][0] + this.arr_datesLowPrice3[i - Number(this._dataCnaNums[3]) + 1][0]) / 2;



              this._data5.push([Number(chartData[i][0]), Number(data_sum4), Number(data_sum5)]);

              this._exceptIdx[4]++;



              this._data6.push([Number(chartData[i][0]), Number(data_sum5), Number(data_sum4)]);

              this._exceptIdx[5]++;



              this._data7.push([Number(chartData[i][0]), Number(data_sum5)]);

              this._exceptIdx[6]++;

            }

          }



          // console.log(chartData[i][6] + "//i=" + i +  "//this._dataCnaNums[4]=" + this._dataCnaNums[4] +  "//dates_high_price3=" + dates_high_price3 + "//dates_low_price3=" + dates_low_price3 + "//data_sum5=" + data_sum5);



        } // for

      }

    },

    /**

     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2015.07.22

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      var data_arr = [this._data1, this._data2, this._data3, this._data4, this._data5, this._data6, this._data7];

      for (var i = 0; i < 7; i++) {

        var data = data_arr[i];

        data[this._exceptIdx[i]][0] = nexUtils.date2Utc(datePoint);



        for (var j = this._exceptIdx[i] + 1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {

          if (interval == 'MINUTE' || interval == 'HOURS') {

            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

          } else {

            data[j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

          }

        }

      }

    },

    /**

     * 한건의 데이터 추가

     * @param chartData 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

     */

    addPointData: function(chartData) {

      if (chartData != null && chartData.length > 0) {

        var date_utc_time = chartData[chartData.length - 1][0];

        var point = this._pExceptIdx; // chartData.length - 1;



        // 기준선(26) = (최근 26일간의 최고치 + 최저치) / 2 (i >= 25 일때 부터)

        if (point >= Number(this._dataCnaNums[0]) - 1) {

          var dates_high_price1 = nexChartUtils.getHighMax(point, this._dataCnaNums[0], chartData);

          var dates_low_price1 = nexChartUtils.getLowMin(point, this._dataCnaNums[0], chartData);



          this.arr_dataSum1[point] = [(dates_high_price1 + dates_low_price1) / 2, chartData[point][0]];



          this._data1.push([Number(date_utc_time), null]);

          this._exceptIdx[0]++;

        } else {

          this.arr_dataSum1[point] = [null, chartData[point][0]];

        }



        // 전환선(9) = (최근 9일간의 최고치 + 최저치) / 2 (i >= 8 일때 부터)

        if (point >= Number(this._dataCnaNums[1]) - 1) {

          var dates_high_price2 = nexChartUtils.getHighMax(point, this._dataCnaNums[1], chartData);

          var dates_low_price2 = nexChartUtils.getLowMin(point, this._dataCnaNums[1], chartData);



          this.arr_dataSum2[point] = [(dates_high_price2 + dates_low_price2) / 2, chartData[point][0]];



          this._data2.push([Number(date_utc_time), null]);

          this._exceptIdx[1]++;

        } else {

          this.arr_dataSum2[point] = [null, chartData[point][0]];

        }



        // 후행스팬(26) 그날의 종가를 26일 후행시킨선

        // if (point <= this._pExceptIdx - this._dataCnaNums[2]) {

        if (this._data3 != null && this._data3.length > 0) {

          this._data3.push([Number(date_utc_time), null]);

          this._exceptIdx[2]++;

        }



        var data_sum4 = null;

        // 단기선행스팬(26) = (기준선 + 전환선) / 2를 26일 선행시킨선 (i >= 50일때 부터)

        if (point >= (Number(this._dataCnaNums[0]) + Number(this._dataCnaNums[3]) - 2)) { //

          data_sum4 = (this.arr_dataSum1[point - Number(this._dataCnaNums[3]) + 1][0] + this.arr_dataSum2[point - Number(this._dataCnaNums[3]) + 1][0]) / 2;



          this._data4.push([Number(date_utc_time), null]);

        }

        this._exceptIdx[3]++;



        var data_sum5 = null;

        // 장기선행스팬(52) = (최근 52일간의 최고치 + 최저치) / 2 를 26일 선행(앞으로)시킨선 (i >= 76일때 부터)

        if (point >= (Number(this._dataCnaNums[4]) - 1)) { // (i >= 51일때 부터)

          var dates_high_price3 = nexChartUtils.getHighMax(point, this._dataCnaNums[4], chartData); // 52일 최고

          var dates_low_price3 = nexChartUtils.getLowMin(point, this._dataCnaNums[4], chartData); // 52일 최저



          this.arr_datesHightPrice3[point] = [dates_high_price3, chartData[point][0]];

          this.arr_datesLowPrice3[point] = [dates_low_price3, chartData[point][0]];



          if (point >= Number(this._dataCnaNums[4]) + Number(this._dataCnaNums[3]) - 2) { // (i >= 76일때부터)

            data_sum5 = (this.arr_datesHightPrice3[point - Number(this._dataCnaNums[3]) + 1][0] + this.arr_datesLowPrice3[point - Number(this._dataCnaNums[3]) + 1][0]) / 2;



            this._data5.push([Number(date_utc_time), null, null]);

            this._exceptIdx[4]++;



            this._data6.push([Number(date_utc_time), null, null]);

            this._exceptIdx[5]++;



            this._data7.push([Number(date_utc_time), null]);

            this._exceptIdx[6]++;

          }

        }

        this._pExceptIdx++;

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2015.07.22

     * 

     * @param point : 업데이트될 위치(index)

     * @param pointData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     */

    updatePointData: function(point, chartData, exceptFlag) {

      if (chartData != null && chartData.length > 0) {

        if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

          exceptFlag = false;

        }



        var date_utc_time = chartData[point][0];



        // 기준선(26) = (최근 26일간의 최고치 + 최저치) / 2 (i >= 25 일때 부터)

        if (point >= Number(this._dataCnaNums[0]) - 1) {

          var dates_high_price1 = nexChartUtils.getHighMax(point, this._dataCnaNums[0], chartData);

          var dates_low_price1 = nexChartUtils.getLowMin(point, this._dataCnaNums[0], chartData);



          this.arr_dataSum1[point] = [(dates_high_price1 + dates_low_price1) / 2, chartData[point][0]];



          this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), Number(this.arr_dataSum1[point][0])];

        } else {

          this.arr_dataSum1[point] = [null, chartData[point][0]];

        }



        // 전환선(9) = (최근 9일간의 최고치 + 최저치) / 2 (i >= 8 일때 부터)

        if (point >= Number(this._dataCnaNums[1]) - 1) {

          var dates_high_price2 = nexChartUtils.getHighMax(point, this._dataCnaNums[1], chartData);

          var dates_low_price2 = nexChartUtils.getLowMin(point, this._dataCnaNums[1], chartData);



          this.arr_dataSum2[point] = [(dates_high_price2 + dates_low_price2) / 2, chartData[point][0]];



          this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point] = [Number(date_utc_time), Number(this.arr_dataSum2[point][0])];

        } else {

          this.arr_dataSum2[point] = [null, chartData[point][0]];

        }



        // 후행스팬(26) 그날의 종가를 26일 후행시킨선

        // if (point <= this._pExceptIdx - this._dataCnaNums[2]) {

        if (this._data3 != null && this._data3.length > 0) {

          var data_sum3 = chartData[point][4];



          this._data3[exceptFlag ? (this._exceptIdx[2] - 1) : point] = [Number(this._data3[exceptFlag ? (this._exceptIdx[2] - 1) : point][0]), Number(data_sum3) == 0 ? null : Number(data_sum3)];

        }



        var data_sum4 = null;

        // 단기선행스팬(26) = (기준선 + 전환선) / 2를 26일 선행시킨선 (i >= 50일때 부터)

        if (point >= (Number(this._dataCnaNums[0]) + Number(this._dataCnaNums[3]) - 2)) { //

          data_sum4 = (this.arr_dataSum1[point][0] + this.arr_dataSum2[point][0]) / 2;



          this._data4[exceptFlag ? (this._exceptIdx[3] - 1) : point] = [Number(this._data4[exceptFlag ? (this._exceptIdx[3] - 1) : point][0]), Number(data_sum4)];

        }



        var data_sum5 = null;

        // 장기선행스팬(52) = (최근 52일간의 최고치 + 최저치) / 2 를 26일 선행(앞으로)시킨선 (i >= 76일때 부터)

        if (point >= (Number(this._dataCnaNums[4]) - 1)) { // (i >= 51일때 부터)

          var dates_high_price3 = nexChartUtils.getHighMax(point, this._dataCnaNums[4], chartData); // 52일 최고

          var dates_low_price3 = nexChartUtils.getLowMin(point, this._dataCnaNums[4], chartData); // 52일 최저



          this.arr_datesHightPrice3[point] = [dates_high_price3, chartData[point][0]];

          this.arr_datesLowPrice3[point] = [dates_low_price3, chartData[point][0]];



          if (point >= Number(this._dataCnaNums[4]) + Number(this._dataCnaNums[3]) - 2) { // (i >= 76일때부터)

            data_sum5 = (this.arr_datesHightPrice3[point][0] + this.arr_datesLowPrice3[point][0]) / 2;



            this._data5[exceptFlag ? (this._exceptIdx[4] - 1) : point] = [Number(this._data5[exceptFlag ? (this._exceptIdx[4] - 1) : point][0]), Number(data_sum4), Number(data_sum5)];

            this._data6[exceptFlag ? (this._exceptIdx[5] - 1) : point] = [Number(this._data6[exceptFlag ? (this._exceptIdx[5] - 1) : point][0]), Number(data_sum5), Number(data_sum4)];

            this._data7[exceptFlag ? (this._exceptIdx[6] - 1) : point] = [Number(this._data7[exceptFlag ? (this._exceptIdx[6] - 1) : point][0]), Number(data_sum5)];

          }

        }

      }

    },

    /**

     * 차트별 전체 데이터 리턴

     * @param dataNum

     * @return {Array}

     */

    getData: function(dataNum) {

      var data = [];

      if (dataNum == 1) {

        data = this._data1;

      } else if (dataNum == 2) {

        data = this._data2;

      } else if (dataNum == 3) {

        data = this._data3;

      } else if (dataNum == 4) {

        data = this._data4;

      } else if (dataNum == 5) {

        data = this._data5;

      } else if (dataNum == 6) {

        data = this._data6;

      } else if (dataNum == 7) {

        data = this._data7;

      }



      return data;

    },

    /**

     * 차트별 index 위치의 데이터 리턴.

     * @param dataNum

     * @param index

     * @return

     */

    getIndexData: function(dataNum, index) {

      var data = this.getData(dataNum);

      return data[index];

    },

    /**

     * 차트별 마지막 데이터 리턴

     * @param dataNum

     * @param exceptFlag: 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     * @return

     */

    getLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }



      var data = this.getData(dataNum);

      var last_len = data.length - 1;



      // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

      if (exceptFlag && this._exceptIdx[dataNum - 1] != 0) {

        last_len = this._exceptIdx[dataNum - 1] - 1;

      }



      return data[last_len];

    },

    /**

     * 빈데이터 시작 IDX

     * @param dataNum

     * @return

     */

    getExceptIdx: function(dataNum) {

      var ret_idx = {};

      if (this._exceptIdx != null && this._exceptIdx.length > 0) {

        ret_idx = this._exceptIdx[dataNum - 1];

      }



      return ret_idx;

    }

  };



	/**

	 * desc : 볼린저 데이터 객체(bollinger) date : 2015.07.22

	 * 

	 */

	var bollingerData = function(chart, seqId, chartData, smaNum1, smaNum2) {

		this._chart = chart;

		this._type = 'bollinger';

		this._id = seqId;

		this._data1 = []; // 상한선

		this._data2 = []; // 중심선

		this._data3 = []; // 하한선



		this._dataSmaNum = smaNum1; // 중심선 이동평균일

		this._stdDev = smaNum2; // Standard Deviations(표준편차승수)



		this._exceptIdx = 0;



		this.arr_m_baseAvg = [];

		this.arr_baseAvg = [];



		this.init();

		this.setData(chartData);

	};

	

	bollingerData.prototype = {

		init : function() {

			this._exceptIdx = 0;

			

			this.arr_m_baseAvg = [];

			this.arr_baseAvg = [];

		},

		/**

		 * desc : 타입 리턴 date : 2015.07.22

		 * @return {String}

		 */

		getType : function() {

			return this._type;

		},

		/**

		 * desc: id 리턴 date : 2015.07.22

		 * @return

		 */

		getId : function() {

			return this._id;

		},

		/**

		 * 중심선 이동평균일 리턴.

		 * @return

		 */

		getSmaNum : function() {

			return this._dataSmaNum;

		},

		/**

		 * desc : 초기 전체 데이터 가공 date : 2015.07.22

		 * 

		 * Bollinger Bands 계산식 평균주가 : 고가+저가+종가 / 3 -> 미래에셋:종가 20160425

		 * 상한밴드 : up_band = avg + (stdDev * sdv) 

		 * 중간밴드 : 평균주가 n일 단순이동평균 

		 * 하한밴드 : down_band = avg - (stdDev * sdv) 기본설정값 : 20일

		 * 

		 * @param chartData : 차트 데이터

		 */

		setData: function(chartData) {

			if (chartData != null && chartData.length > 0) {

				var m_base_avg = 0;

				for (var i = 0, len = chartData.length; i < len; i++) {

					// 빈데이터(현재일 + 26일) 있을 경우 빈데이터 제외하고 데이터 처리

					if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

						var up_band = null;

						var avg = null;

						var down_band = null;

						//var base_avg = Number((chartData[i][2] + chartData[i][3] + chartData[i][4]) / 3);

						var base_avg = Number(chartData[i][4]);

						

						this.arr_baseAvg[i] = base_avg;



						if (i >= this._dataSmaNum - 1) {

							m_base_avg += base_avg;

							this.arr_m_baseAvg[i - 1] = m_base_avg;



							if (i == this._dataSmaNum - 1) { // 중간밴드 (이동 평균값) : i 가 this._day 와 같을때 이동평균

								avg = m_base_avg / this._dataSmaNum;

							} else { // 중간밴드 (이동 평균값) : i 가 this._day 보다 클때 이동평균

								avg = (m_base_avg - this.arr_m_baseAvg[i - this._dataSmaNum - 1]) / this._dataSmaNum;

							}



							// 표준편차 구하기

							var di_sum = 0;

							var deviation = 0;



							for (var j = 0, dsn_len = this._dataSmaNum; j < dsn_len; j++) {

								deviation = this.arr_baseAvg[i - j] - avg;

								// var deviation = chartData[i-j][4] - avg;

								di_sum += Math.pow(deviation, 2);

							}



							di_sum = Math.sqrt(di_sum / this._dataSmaNum);



							up_band = avg + (di_sum * this._stdDev); // 상한밴드

							down_band = avg - (di_sum * this._stdDev); // 하한밴드

							up_band = Number(up_band.toFixed(2));

							down_band = Number(down_band.toFixed(2));



							avg = Number(avg.toFixed(2));

						} else {

							m_base_avg += base_avg;

							this.arr_m_baseAvg[i - 1] = m_base_avg;

						}



			            this._data1.push([Number(chartData[i][0]), up_band]);

			            this._data2.push([Number(chartData[i][0]), avg]);

			            this._data3.push([Number(chartData[i][0]), down_band]);



			            this._exceptIdx++;

					} else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

						this._data1.push([Number(chartData[i][0]), null]);

						this._data2.push([Number(chartData[i][0]), null]);

						this._data3.push([Number(chartData[i][0]), null]);



						this.arr_baseAvg[i] = 0;

						this.arr_m_baseAvg[i - 1] = 0;

					}

				}

			}

		},

	    /**

		 * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리) date : 2015.07.22

		 * 

		 * @param datePoint

		 * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

		 * @param unit

		 */

		datePointChangeData : function(datePoint, interval, unit) {

			var data_arr = [ this._data1, this._data2, this._data3 ];

			for (var i = 0; i < 3; i++) {

				var data = data_arr[i];

				data[this._exceptIdx+1][0] = nexUtils.date2Utc(datePoint);



				for (var j = this._exceptIdx+1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {

					if (interval == 'MINUTE' || interval == 'HOURS') {

						data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

					} else {

						data[j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

					}

				}

			}

		},

	    /**

		 * desc : 한건의 데이터 추가 date : 2015.07.22

		 * 

		 * @param pointData : 한건의 데이터

		 */

	    addPointData: function(pointData) {

	    	if (pointData != null && pointData.length > 0) {

	    		// 빈데이터 추가

	    		this._data1.push([Number(pointData[0]), null]);

	    		this._data2.push([Number(pointData[0]), null]);

	    		this._data3.push([Number(pointData[0]), null]);

	

	    		this._exceptIdx++;

	    	}

	    },

	    /**

	     * desc : 한건의 데이터 수정

	     * date : 2015.07.22

	     * 

	     * @param point : 업데이트될 위치(index)

	     * @param pointData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

	     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

	     */

	    updatePointData: function(point, chartData, exceptFlag) {

	    	if (chartData != null && chartData.length > 0) {

	    		if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

	    			exceptFlag = false;

	    		}

	    		

	    		var date_utc_time = chartData[point][0];

	    		var up_band = null;

	    		var avg = null;

	    		var down_band = null;

	    		var m_base_avg = 0;

	    		//var base_avg = Number((chartData[point][2] + chartData[point][3] + chartData[point][4]) / 3);

	    		var base_avg = Number(chartData[point][4]);

	

	    		this.arr_baseAvg[point] = base_avg;

	

	    		if (point >= this._dataSmaNum - 1) {

	    			m_base_avg = this.arr_m_baseAvg[point - 2] + base_avg;

	    			this.arr_m_baseAvg[point - 1] = m_base_avg;

	    			

	    			if (point == this._dataSmaNum - 1) { // 중간밴드 (이동 평균값) : i 가 this._day 와 같을때 이동평균

	    				avg = m_base_avg / this._dataSmaNum;

	    			} else { // 중간밴드 (이동 평균값) : i 가 this._day 보다 클때 이동평균

	    				avg = (m_base_avg - this.arr_m_baseAvg[point - this._dataSmaNum - 1]) / this._dataSmaNum;

	    			}

	

	    			// 표준편차 구하기

	    			var di_sum = 0;

	    			var deviation = 0;

	

	    			for (var j = 0, dsn_len = this._dataSmaNum; j < dsn_len; j++) {

	    				deviation = this.arr_baseAvg[point - j] - avg;

	    				// var deviation = chartData[i-j][4] - avg;

	    				di_sum += Math.pow(deviation, 2);

	    			}

	

	    			di_sum = Math.sqrt(di_sum / this._dataSmaNum);

	

	    			up_band = avg + (di_sum * this._stdDev); // 상한밴드

	    			down_band = avg - (di_sum * this._stdDev); // 하한밴드

	    			up_band = Number(up_band.toFixed(2));

	    			down_band = Number(down_band.toFixed(2));

	

	    			avg = Number(avg.toFixed(2));

	    		} else {

	    			m_base_avg += base_avg;

	    			this.arr_m_baseAvg[point - 1] = m_base_avg;

	    		}

	

	    		this._data1[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), up_band];

	    		this._data2[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), avg];

	        	this._data3[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), down_band];

	    	}

	    },

	    /**

	     * 차트별 전체 데이터 리턴.

	     * @param dataNum

	     * @return {Array}

	     */

	    getData: function(dataNum) {

	    	var data = [];

			if (dataNum == 1) {

				data = this._data1;

			} else if (dataNum == 2) {

				data = this._data2;

			} else if (dataNum == 3) {

				data = this._data3;

			}

			return data;

	    },

	    /**

		 * 차트별 index 위치에 데이터 리턴

		 * 

		 * @param dataNum

		 * @param index

		 * @return

		 */

	    getIndexData: function(dataNum, index) {

	    	var data = this.getData(dataNum);

	    	return data[index];

	    },

	    /**

	     * 차트별 마지막 데이터 리턴

	     * @param dataNum

	     * @param exceptFlag: 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

	     * @return

	     */

	    getLastData: function(dataNum, exceptFlag) {

	    	if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

	    		exceptFlag = true;

	    	}

	    	var data = this.getData(dataNum),

	    	last_len = data.length - 1;

	

	    	// 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

	    	if (exceptFlag && this._exceptIdx != 0) {

	    		last_len = this._exceptIdx - 1;

	    	}

	    	return data[last_len];

	    },

	    /**

	     * desc : 빈데이터 시작 IDX 반환

	     * date : 2015.07.22

	     * 

	     * @return {Number}

	     */

	    getExceptIdx: function() {

	    	return this._exceptIdx;

	    }

	};



  /**

   * desc : 엔빌로프 데이터 객체(envelope)

   * date : 2015.07.22

   * 

   */

  var envelopeData = function(chart, seqId, chartData, smaNum, factor) {

	 this._chart = chart;

	 this._type = 'envelope';

    this._id = seqId;

    this._data1 = []; //상한선

    this._data2 = []; //중심선

    this._data3 = []; //하한선

    this._dataSmaNum = smaNum; //중심선 이동평균일

    this._factor = factor / 100; //가감값



    this._exceptIdx = 0;



    this.arr_smaSum = [];



    this.init();

    this.setData(chartData);

  }

  envelopeData.prototype = {

    init: function() {

      this._exceptIdx = 0;

      this.arr_smaSum = [];

    },

    /**

     * desc : 타입 리턴

     * date : 2015.07.22

     * 

     * @return {String}

     */

    getType: function() {

      return this._type;

    },

    /**

     * desc: id 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getId: function() {

      return this._id;

    },

    //중심선 이동평균일 리턴.

    getSmaNum: function() {

      return this._dataSmaNum;

    },

    //가감값 리턴.

    getFactor: function() {

      return this._factor;

    },

    /**

     * desc : 초기 전체 데이터 가공

     * date : 2015.07.22

     * 

     *

     * Envelope 계산식

     * 중심선 : 종가 n일 단순이동평균

     * 상한선 : n일 단순이평 X (1 + 비율)

     * 하한선 : n일 단순이평 X (1 - 비율)

     * 기본값 : 이평기간 13일, 비율 8%

     * @param chartData : 차트 데이터

     */

    setData: function(chartData) {

      if (chartData != null && chartData.length > 0) {

        this.arr_smaSum[0] = chartData[0][4];

        for (var i = 0, len = chartData.length; i < len; i++) {

          var avg = null;

          var envelop_up = null;

          var envelop_down = null;



          // 빈데이터(현재일 + 26일) 있을 경우 빈데이터 제외하고 데이터 처리

          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

            if (i >= this._dataSmaNum - 1) {

              this.arr_smaSum[i] = this.arr_smaSum[i - 1] + chartData[i][4];



              if (i - (this._dataSmaNum - 1) > 0) {

                this.arr_smaSum[i] -= chartData[i - this._dataSmaNum][4];

              }



              avg = this.arr_smaSum[i] / this._dataSmaNum; //이동 평균값(중심선)

              envelop_up = avg + (avg * this._factor); //상한선( 이동평균값 + (이동평균값 * factor) )

              envelop_down = avg - (avg * this._factor); //하한선( 이동평균값 - (이동평균값 * factor) )



              avg = Number(avg.toFixed(2));

              envelop_up = Number(envelop_up.toFixed(2));

              envelop_down = Number(envelop_down.toFixed(2));

            } else {

              if (i > 0) {

                this.arr_smaSum[i] = this.arr_smaSum[i - 1] + chartData[i][4];

              }

            }



            this._data1.push([Number(chartData[i][0]), envelop_up]);

            this._data2.push([Number(chartData[i][0]), avg]);

            this._data3.push([Number(chartData[i][0]), envelop_down]);



            this._exceptIdx++;

          } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

            this._data1.push([Number(chartData[i][0]), null]);

            this._data2.push([Number(chartData[i][0]), null]);

            this._data3.push([Number(chartData[i][0]), null]);



            this.arr_smaSum[i] = 0;

          }

        }

      }

    },

    /**

     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2015.07.22

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      var data_arr = [this._data1, this._data2, this._data3];

      for (var i = 0; i < 3; i++) {

        var data = data_arr[i];

        data[this._exceptIdx+1][0] = nexUtils.date2Utc(datePoint);



        for (var j = this._exceptIdx+1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {

          if (interval == 'MINUTE' || interval == 'HOURS') {

            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

          } else {

            data[j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

          }

        }

      }

    },

    /**

     * desc : 한건의 데이터 추가

     * date : 2015.07.22

     * 

     * @param pointData : 한건의 데이터

     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) { // 빈데이터 추가

        this._data1.push([Number(pointData[0]), null]);

        this._data2.push([Number(pointData[0]), null]);

        this._data3.push([Number(pointData[0]), null]);

        this._exceptIdx++;

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2015.07.22

     * 

     * @param point : 업데이트될 위치(index)

     * @param pointData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     */

    updatePointData: function(point, chartData, exceptFlag) {

      if (chartData != null && chartData.length > 0) {

        if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

          exceptFlag = false;

        }



        var date_utc_time = chartData[point][0];

        var avg = null;

        var envelop_up = null;

        var envelop_down = null;



        if (point >= this._dataSmaNum - 1) {

          this.arr_smaSum[point] = this.arr_smaSum[point - 1] + chartData[point][4];



          if (point - (this._dataSmaNum - 1) > 0) {

            this.arr_smaSum[point] -= chartData[point - this._dataSmaNum][4];

          }



          avg = this.arr_smaSum[point] / this._dataSmaNum; //이동 평균값(중심선)

          envelop_up = avg + (avg * this._factor); //상한선( 이동평균값 + (이동평균값 * factor) )

          envelop_down = avg - (avg * this._factor); //하한선( 이동평균값 - (이동평균값 * factor) )



          avg = Number(avg.toFixed(2));

          envelop_up = Number(envelop_up.toFixed(2));

          envelop_down = Number(envelop_down.toFixed(2));



        } else {

          this.arr_smaSum[point] = this.arr_smaSum[point - 1] + chartData[point][4];

        }



        this._data1[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), envelop_up];

        this._data2[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), avg];

        this._data3[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), envelop_down];

      }

    },

    /**

     * desc : 전체 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @return {Array}

     */

    getData: function(dataNum) {

      var data = [];

      if (dataNum == 1) {

        data = this._data1;

      } else if (dataNum == 2) {

        data = this._data2;

      } else if (dataNum == 3) {

        data = this._data3;

      }

      return data;

    },

    /**

     * desc : index 위치의 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param index : 위치

     * @return {Number}

     */

    getIndexData: function(dataNum, index) {

      var data = this.getData(dataNum);

      return data[index];

    },

    /**

     * 차트별 마지막 데이터 리턴

     * @param dataNum

     * @param exceptFlag: 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     * @return

     */

    getLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }

      var data = this.getData(dataNum);

      var last_len = data.length - 1;



      // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

      if (exceptFlag && this._exceptIdx != 0) {

        last_len = this._exceptIdx - 1;

      }

      return data[last_len];

    },

    /**

     * desc : 빈데이터 시작 IDX 반환

     * date : 2015.07.22

     * 

     * @return {Number}

     */

    getExceptIdx: function() {

      return this._exceptIdx;

    }

  };

  



 var parabolicData = function(chart, seqId, chartData, afmax) {

	 this._chart = chart;

     this._type = 'parabolic';

     this._id = seqId;

     this._data = [];

     this._af = 0.02;

     this._af_max = Number(afmax);

     

     this._exceptIdx = 0;

     this.arr_sar = [];

     this.arr_nex_sar =[];

     

     this.init();

     this.setData(chartData);

 };



 parabolicData.prototype = {



     init: function() {

    	this.arr_sar = [];

    	this.arr_nex_sar =[];

     	this._exceptIdx = 0;

     },



     /**

      * Parabollic Sar

      * 타입 리턴

      * @returns {String}

      */

     getType: function() {

         return this._type;

     },



     /**

      * Parabollic Sar

      * id 리턴

      * @returns

      */

     getId: function() {

         return this._id;

     },

     

     /**

      * Parabollic Sar

      * 초기 전체 데이터 가공

      * Parabolic SAR (Stop and Reversal) 계산식

      * 상승추세 : 익일 parabolic = 당일 Parabolic + 가속도(추세내의 신고가 - 당일SAR)

      * 하락추세 : 익일 parabolic = 당일 parabolic + 가속도(추세내의 신저가 - 당일SAR)

      * 기본설정값 초기가속변수:0.02, 증가값: 0.02, 한계값: 0.2

      * 

      * @param chartData 차트 기본 전체 데이터.

      */

     setData: function(chartData) {

         if (chartData != null && chartData.length > 0) {

        	 var trend = null;

        	 var ep1 = 0;

             var sar = 0;

             var ep = 0;

             var up = null;

             var down = null;

	         var af = this._af;

	         var af_max = this._af_max;

	         var sar_color;

	         var exceptFlag = false;

	

	         for (var i = 0; i < chartData.length; i++) {

	         	// 처음 데이터

	         	if (i == 0) {

	                 if (chartData[i][4] >= chartData[i][1]) {

	                     //상승추세

	                     trend = 'up';

	                     ep = chartData[i][3];

	                 } else {

	                     //하락추세

	                     trend = 'down';

	                     ep = chartData[i][2];

	                 }

	                 if (trend == 'up') sar_color = Highcharts.getOptions().colors[1];

                     else sar_color = Highcharts.getOptions().colors[0];

	                 

	                 this.arr_sar[i] = Number(chartData[i][4].toFixed(2));

	                 this._data.push({

	                     x: Number(chartData[i][0]),

	                     y: Number(chartData[i][4].toFixed(2)),

	                     trend: trend,

	                     af: Number(af),

	                     ep: Number(ep),

	                     color: sar_color

	                 });

	             } else {

	                 if (trend == 'up') {

	                     // 전일 추세가 상승일때

	                     if (this.arr_nex_sar[i-1] < chartData[i][2]) { // 전일 SAR < 당일고가

	                         // 추세가 하락으로 전환

	                         trend = 'down';

	                         af = this._af;

	                         ep1 = ep;

	                         ep = Math.min(ep, chartData[i][3]);

	                         sar = this.arr_sar[i-1] + (ep1 - this.arr_sar[i-1]);

	                         up = false;

	                         down = true;

	                     } else {

	                         trend = 'up';

	                         ep1 = ep;

	                         ep = Math.min(ep, chartData[i][3]);

	                         sar = this.arr_sar[i-1] + af * (ep1 - this.arr_sar[i-1]);

	                         up = false;

	                         down = false;

	                         if (ep1 != ep){

	                        	 if (af >= af_max) {

	                        		 af = af_max;

	                        	 } else {

	                        		 af = Number((af + this._af).toFixed(3));

	                        	 }	                        	 

	                         }

	                     }

	                 } else if (trend == 'down') {

	                     //전일 추세가 하락일때

	

	                     if (this.arr_nex_sar[i-1] > chartData[i][3]) {

	                         //추세가 상승으로 전환

	                         trend = 'up';

	                         af = this._af;

	                         ep1 = ep;

	                         ep = Math.max(ep, chartData[i][2]);

	                         sar = this.arr_sar[i-1] + (ep1 - this.arr_sar[i-1]);

	                         up = true;

	                         down = false;

	                     } else {

	                         trend = 'down';

	                         ep1 = ep;

	                         ep = Math.max(ep, chartData[i][2]);

	                         sar = this.arr_sar[i-1] + af * (ep1 - this.arr_sar[i-1]);

	                         up = false;

	                         down = false;

	                         if (ep1 != ep){

	                        	 if (af >= af_max) {

	                        		 af = af_max;

	                        	 } else {

	                        		 af = Number((af + this._af).toFixed(3));

	                        	 }	                        	 

	                         }

	                     }

	                 }

	

	                 if (up == true) {

	                     ep = chartData[i][3];

	                 } else if (down == true) {

	                     ep = chartData[i][2];

	                 }

	                 

	                 this.arr_nex_sar[i]  = sar + (af * (ep - sar));

	                 this.arr_sar[i] = sar;

	                 if (trend == 'up') sar_color = Highcharts.getOptions().colors[1];

                     else sar_color = Highcharts.getOptions().colors[0];

	                 // 빈데이터(현재일 + 26일) 있을 경우 빈데이터 제외하고 데이터 처리 

	                 if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

	                     this._data.push({

	                         x: Number(chartData[i][0]),

	                         y: Number(sar.toFixed(2)),

	                         trend: trend,

	                         af: Number(af),

	                         ep: Number(ep),

	                         color: sar_color

	                     });

	                 } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

	

	                     // 빈데이터 시작 IDX setting

	                     if (!exceptFlag) {

	                         this._exceptIdx = i;

	                         exceptFlag = true;

	                     }

	

	                     this._data.push({

	                         x: Number(chartData[i][0]),

	                         y: null,

	                         trend: null,

	                         af: null,

	                         ep: null,

	                         color: null

	                     });

	                 }

	             }

	         }

         }

     },

     

     datePointChangeData: function(datePoint, interval, unit) {

	   this._data[this._exceptIdx][0] = nexUtils.date2Utc(datePoint);

	      for (var i = this._exceptIdx + 1, len = this._data.length, up_cnt = 1; i < len; i++, up_cnt++) {

	        if (interval == 'MINUTE' || interval == 'HOURS') {

	          this._data[i]['x'] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

	        } else {

	          this._data[i]['x'] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

	        }

	      }

     },

     

     /**

      * Parabollic Sar

      * 한건의 데이터 추가

      * @param pointData 한건의 데이터

      */

     addPointData: function(pointData) {

         if (pointData != null && pointData.length > 0) {

                 

        	 this._data.push({

                 x: Number(pointData[0]),

                 y: null,

                 trend: null,

                 af: null,

                 ep: null,

                 color: null

             });

         	

         	this._exceptIdx++;

         }

     },

     

     /**

      * Parabollic Sar

      * 한건의 데이터 수정

      * @param point 업데이트될 위치(index)

      * @param pointData 한건의 데이터

      */

     updatePointData: function(point, chartData, exceptFlag) {

    	 if (chartData != null && chartData.length > 0) {

	     	 var trend = this._data[point-1]['trend'];

	    	 var ep1 = 0;

	         var sar = this.arr_nex_sar[point-1];

	         var ep = this._data[point-1]['ep'];

	         var up = null;

	         var down = null;

	         var af = this._data[point-1]['af'];

	         var af_max = this._af_max;

	         var sar_color = null;



	         

         	// 처음 데이터

	         if (point == 0) {

                 if (chartData[point][4] >= chartData[point][1]) {

                     //상승추세

                     trend = 'up';

                     ep = chartData[point][3];

                 } else {

                     //하락추세

                     trend = 'down';

                     ep = chartData[point][2];

                 }

                 if (trend == 'up') sar_color = Highcharts.getOptions().colors[1];

                 else sar_color = Highcharts.getOptions().colors[0];

                 

                 this.arr_sar[point] = Number(chartData[point][4].toFixed(2));

                 this._data[exceptFlag ? (this._exceptIdx - 1) : point] = {

                     x: Number(chartData[point][0]),

                     y: Number(chartData[point][4].toFixed(2)),

                     trend: trend,

                     af: Number(af),

                     ep: Number(ep),

                     color: sar_color

                 };

             } else {

                 if (trend == 'up') {

                     // 전일 추세가 상승일때

                     if (this.arr_nex_sar[point-1] < chartData[point][2]) { // 전일 SAR < 당일고가

                         // 추세가 하락으로 전환

                         trend = 'down';

                         af = this._af;

                         ep1 = ep;

                         ep = Math.min(ep, chartData[point][3]);

                         sar = this.arr_sar[point-1] + (ep1 - this.arr_sar[point-1]);

                         up = false;

                         down = true;

                     } else {

                         trend = 'up';

                         ep1 = ep;

                         ep = Math.min(ep, chartData[point][3]);

                         sar = this.arr_sar[point-1] + af * (ep1 - this.arr_sar[point-1]);

                         up = false;

                         down = false;

                         if (ep1 != ep){

                        	 if (af >= af_max) {

                        		 af = af_max;

                        	 } else {

                        		 af = Number((af + this._af).toFixed(3));

                        	 }	                        	 

                         }

                     }

                 } else if (trend == 'down') {

                     //전일 추세가 하락일때



                     if (this.arr_nex_sar[point-1] > chartData[point][3]) {

                         //추세가 상승으로 전환

                         trend = 'up';

                         af = this._af;

                         ep1 = ep;

                         ep = Math.max(ep, chartData[point][2]);

                         sar = this.arr_sar[point-1] + (ep1 - this.arr_sar[point-1]);

                         up = true;

                         down = false;

                     } else {

                         trend = 'down';

                         ep1 = ep;

                         ep = Math.max(ep, chartData[point][2]);

                         sar = this.arr_sar[point-1] + af * (ep1 - this.arr_sar[point-1]);

                         up = false;

                         down = false;

                         if (ep1 != ep){

                        	 if (af >= af_max) {

                        		 af = af_max;

                        	 } else {

                        		 af = Number((af + this._af).toFixed(3));

                        	 }	                        	 

                         }

                     }

                 }



                 if (up == true) {

                     ep = chartData[point][3];

                 } else if (down == true) {

                     ep = chartData[point][2];

                 }

	             

	             this.arr_nex_sar[point] = sar + (af * (ep - sar));

	             this.arr_sar[point] = sar;

	             if (trend == 'up') sar_color = Highcharts.getOptions().colors[1];

	             else sar_color = Highcharts.getOptions().colors[0];

	             // 빈데이터(현재일 + 26일) 있을 경우 빈데이터 제외하고 데이터 처리 

	             if (typeof chartData[point][6] == 'undefined' || chartData[point][6] == null || chartData[point][6] != 'except') {

	                 this._data[exceptFlag ? (this._exceptIdx - 1) : point] = {

	                     x: Number(chartData[point][0]),

	                     y: Number(sar.toFixed(2)),

	                     trend: trend,

	                     af: Number(af),

	                     ep: Number(ep),

	                     color: sar_color

	                 };

	             } else if (chartData[point][6] != 'undefined' && chartData[point][6] != null && chartData[point][6] == 'except') {

	

	                 // 빈데이터 시작 IDX setting

	                 if (!exceptFlag) {

	                     this._exceptIdx = point;

	                     exceptFlag = true;

	                 }

	

	                 this._data[exceptFlag ? (this._exceptIdx - 1) : point] = {

	                     x: Number(chartData[point][0]),

	                     y: null,

	                     trend: null,

	                     af: null,

	                     ep: null,

	                     color: null

	                 };

	             }

	         }

    	 }

     },



     /**

      * Parabollic Sar

      * 전체 데이터 리턴

      * @returns {Array}

      */

     getData: function() {

         return this._data;

     },



     /**

      * Parabollic Sar

      * index 위치의 데이터 리턴

      * @param index

      * @returns

      */

     getIndexData: function(index) {

         return this._data[index];

     },



     /**

      * Parabollic Sar

      * index 위치의 데이터 복사하여 리턴

      * @param index

      * @returns {}

      */

     getCloneIndexData: function(index) {

         

         return {

             x: this._data[index].x,

             y: this._data[index].y,

             color: this._data[index].color

         };

     },



     /**

      * Parabollic Sar

      * 마지막 데이터를 복사하여 리턴

      * @param exceptFlag: 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

      * @returns {}

      */

     getCloneLastData: function(exceptFlag) {

         

     	if(typeof exceptFlag == 'undefined' || exceptFlag == null) {

     		exceptFlag = true;

     	}

     	

     	var lastLen = this._data.length - 1;



         // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

         if (exceptFlag && this._exceptIdx != 0) {

             lastLen = this._exceptIdx - 1;

         }



         return {

             x: this._data[lastLen].x,

             y: this._data[lastLen].y,

             color: this._data[lastLen].color

         };

     }, 

     

     /**

      * Parabollic Sar

      * 빈데이터 시작 IDX

      * @returns

      */

     getExceptIdx: function() {

         return this._exceptIdx;

       }

 };



  /**

   * desc : 그물 데이터 객체(maribbon)

   * date : 2015.07.22

   * 

   */

  var maRibbonData = function(chart, seqId, chartData, smaNum, inc, rCnt) {

	 this._chart = chart;

	 this._type = 'maribbon';

    this._id = seqId;

    this._data = [];

    this._smaNum = smaNum; //기준이평선(시작이평)

    this._inc = inc; //증가간격

    this._rCnt = rCnt; //이평선수(개수)



    this._exceptIdx = [];



    this.arr_dataSum = [];



    this.init();

    this.setData(chartData);

  }

  maRibbonData.prototype = {

    init: function() {

      for (var i = 0, len = this._rCnt; i < len; i++) {

        this._exceptIdx[i] = 0;

        this.arr_dataSum[i] = [];

        this._data[i] = [];

      }

    },

    /**

     * desc : 타입 리턴

     * date : 2015.07.22

     * 

     * @return {String}

     */

    getType: function() {

      return this._type;

    },

    /**

     * desc: id 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getId: function() {

      return this._id;

    },

    /**

     * desc : 기준 이동평균일 반환.

     * date : 2015.07.22

     * 

     * @return

     */

    getSmaNum: function() {

      return this._smaNum;

    },

    /**

     * desc : 증가값 반환

     * date : 2015.07.22

     * 

     * @return

     */

    getInc: function() {

      return this._inc;

    },

    /**

     * desc : 갯수값 반환

     * date : 2015.07.22

     * 

     * @return

     */

    getRcnt: function() {

      return this._rCnt;

    },

    /**

     * desc : 초기 전체 데이터 가공

     * date : 2015.07.22

     * 

     *

     * 그물차트 : 이동 평균선을 짧은 것부터 긴 것을 순차적 나열 (기본설정값 : 시작이평 5, 증가간격 1, 이평선수 15)

     *

     * @param chartData : 차트 데이터

     */

    setData: function(chartData) {

      if (chartData != null && chartData.length > 0) {

        // i : 이평선수, j : 데이타 일련번호

        for (var i = 0; i < this._rCnt; i++) {

          var data_sma_num = i * this._inc + this._smaNum;



          this.arr_dataSum[i][0] = chartData[0][4];

          for (var j = 0, len = chartData.length; j < len; j++) {

            // 빈데이터(현재일 + 26일) 있을 경우 빈데이터 제외하고 데이터 처리

            if (typeof chartData[j][6] == 'undefined' || chartData[j][6] == null || chartData[j][6] != 'except') {

              if (j >= data_sma_num - 1) {

                this.arr_dataSum[i][j] = this.arr_dataSum[i][j - 1] + chartData[j][4];

                if (j - (data_sma_num - 1) > 0) {

                  this.arr_dataSum[i][j] -= chartData[j - data_sma_num][4];

                }

                this._data[i].push([Number(chartData[j][0]), Number((this.arr_dataSum[i][j] / data_sma_num).toFixed(2))]);

              } else {

                if (j > 0) {

                  this.arr_dataSum[i][j] = this.arr_dataSum[i][j - 1] + chartData[j][4];

                }

                this._data[i].push([Number(chartData[j][0]), null]);

              }

              this._exceptIdx[i]++;

            } else if (chartData[j][6] != 'undefined' && chartData[j][6] != null && chartData[j][6] == 'except') {

              this._data[i].push([Number(chartData[j][0]), null]);

              this.arr_dataSum[i][j] = 0;

            }

          }

        }

      }

    },

    /**

     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2015.07.22

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      for (var i = 0; i < this._rCnt; i++) {

        this._data[i][this._exceptIdx[i]][0] = nexUtils.date2Utc(datePoint);

        for (var j = this._exceptIdx[i] + 1, len = this._data[i].length, up_cnt = 1; j < len; j++, up_cnt++) {

          if (interval == 'MINUTE' || interval == 'HOURS') {

            this._data[i][j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

          } else {

            this._data[i][j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

          }

        }

      }

    },

    /**

     * desc : 한건의 데이터 추가

     * date : 2015.07.22

     * 

     * @param pointData : 한건의 데이터

     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) {

        // i : 이평선수, j : 데이타 일련번호

        for (var i = 0; i < this._rCnt; i++) {

          this._data[i].push([Number(pointData[0]), null]);

          this._exceptIdx[i]++;

        }

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2015.07.22

     * 

     * @param point : 업데이트될 위치(index)

     * @param pointData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     */

    updatePointData: function(point, chartData, exceptFlag) {

      if (chartData != null && chartData.length > 0) {

        if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

          exceptFlag = false;

        }

        var date_utc_time = chartData[point][0];

        // i : 이평선수, j : 데이타 일련번호

        for (var i = 0; i < this._rCnt; i++) {

          var data_sma_num = i * this._inc + this._smaNum;

          if (point >= data_sma_num - 1) {

            this.arr_dataSum[i][point] = this.arr_dataSum[i][point - 1] + chartData[point][4];

            if (point - (data_sma_num - 1) > 0) {

              this.arr_dataSum[i][point] -= chartData[point - data_sma_num][4];

            }

            this._data[i][exceptFlag ? (this._exceptIdx[i] - 1) : point] = [Number(date_utc_time), Number((this.arr_dataSum[i][point] / data_sma_num).toFixed(2))];

          } else {

            this.arr_dataSum[i][point] = this.arr_dataSum[i][point - 1] + chartData[point][4];

            this._data[i][exceptFlag ? (this._exceptIdx[i] - 1) : point] = [Number(date_utc_time), null];

          }

        }

      }

    },

    /**

     * desc : 전체 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @return {Array}

     */

    getData: function(dataNum) {

      return this._data[dataNum];

    },

    /**

     * desc : index 위치의 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param index : 위치

     * @return {Number}

     */

    getIndexData: function(dataNum, index) {

      return this._data[dataNum][index];

    },

    /**

     * desc : 마지막 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param exceptflag : 빈데이터 제외 flag(true: 제외, false: 포함, default: true)

     * @return

     */

    getLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }



      var last_len = this._data[dataNum].length - 1;

      // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

      if (exceptFlag && this._exceptIdx[dataNum] != 0) {

        last_len = this._exceptIdx[dataNum] - 1;

      }



      return this._data[dataNum][last_len];

    },

    /**

     * desc : 빈데이터 시작 IDX 반환

     * date : 2015.07.22

     * 

     * @param : 가져올 데이터의 index

     * @return {Number}

     */

    getExceptIdx: function(dataNum) {

      var ret_idx = {};

      if (this._exceptIdx != null && this._exceptIdx.length > 0) {

        ret_idx = this._exceptIdx[dataNum];

      }



      return ret_idx;

    }

  };



  /**

   * desc : MACD 데이터 객체(macd)

   * date : 2015.07.22

   * 

   */

  var macdData = function(chart, seqId, chartData, emaNum1, emaNum2, signal) {

	 this._chart = chart;

	 this._type = 'macd';

    this._id = seqId;

    this._data1 = []; //macd선

    this._data2 = []; //시그널선

    this._data3 = []; //OSC막대

    this._emaNum1 = emaNum1; //지수 이평선1

    this._emaNum2 = emaNum2; //지수 이평선2

    this._signal = signal; //signal



    this._exceptIdx = [];

    this.arr_signal = [];

    this.arr_ema1 = [];

    this.arr_ema2 = [];



    this.init();

    this.setData(chartData);

  }

  macdData.prototype = {

    init: function() {

      this._exceptIdx[0] = 0;

      this._exceptIdx[1] = 0;

      this._exceptIdx[2] = 0;



      this.arr_signal = [];

      this.arr_ema1 = [];

      this.arr_ema2 = [];

    },

    /**

     * desc : 타입 리턴

     * date : 2015.07.22

     * 

     * @return {String}

     */

    getType: function() {

      return this._type;

    },

    /**

     * desc: id 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getId: function() {

      return this._id;

    },

    /**

     * desc: 지수이평선1값 반환

     * date : 2015.07.22

     * 

     * @return

     */

    getEmaNum1: function() {

      return this._emaNum1;

    },

    /**

     * desc: 지수이평선2값 반환

     * date : 2015.07.22

     * 

     * @return

     */

    getEmaNum2: function() {

      return this._emaNum2;

    },

    /**

     * desc: 시그널값 반환

     * date : 2015.07.22

     * 

     * @return

     */

    getSignal: function() {

      return this._signal;

    },

    /**

     * desc : 초기 전체 데이터 가공

     * date : 2015.07.22

     * 

     *

     * MACD (Moving Average Convergence and Divergence) 계산

     * MACD = 단기지수이동평균 - 장기지수이동평균

     * Signal = n일의 MACD 지수이동평균

     * OSC = MACD - Signal (막대차트표시)

     * 기본설정값: 단기:12일, 장기:26일, Signal:9일

     * EMA (지수이동평균) = C * K +Xp(1-K) (C : 당일치, Xp : 전일이동평균, K(exponential percentage)=2/(n+1))

     *

     * @param chartData : 차트 데이터

     */

    setData: function(chartData) {

      if (chartData != null && chartData.length > 0) {

        var factor1 = 2 / (this._emaNum1 + 1);

        var factor2 = 2 / (this._emaNum2 + 1);

        var factor3 = 2 / (this._signal + 1);



        for (var i = 0, len = chartData.length; i < len; i++) {

          // 빈데이터(현재일 + 26일) 있을 경우 빈데이터 제외하고 데이터 처리

          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

            var macd = null;

            // emaNum1, emaNum2 에 대한 지수 이평선

            if (i >= 0) {

              if (i == 0) {

                this.arr_ema1[i] = chartData[i][4];

                this.arr_ema2[i] = chartData[i][4];

              } else {

                //this.arr_ema1[i] = chartData[i][4] * factor1 + (1 - factor1) * this.arr_ema1[i - 1]; // 지수이평

                this.arr_ema1[i] = nexChartUtils.calcSma(chartData,4,i,this._emaNum1); // 단순이평

                //this.arr_ema2[i] = chartData[i][4] * factor2 + (1 - factor2) * this.arr_ema2[i - 1]; // 지수이평

                this.arr_ema2[i] = nexChartUtils.calcSma(chartData,4,i,this._emaNum2); // 단순이평

              }

            }



            // MACD 구하기.

            if (i >= this._emaNum2 - 1) {

              macd = this.arr_ema1[i] - this.arr_ema2[i];



              this._data1.push({

                x: Number(chartData[i][0]),

                y: Number(macd.toFixed(2)),

                ema1: Number(this.arr_ema1[i]),

                ema2: Number(this.arr_ema2[i])

              });



              // signal 구하기

              if (i == this._emaNum2 - 1) {

                this.arr_signal[i] = macd;

              } else {

                //this.arr_signal[i] = macd * factor3 + (1 - factor3) * this.arr_signal[i - 1]; // 지수이평

            	  this.arr_signal[i] = nexChartUtils.calcSma(this._data1,'y',i,this._signal); // 단순이평

              }

            } else {

              this._data1.push({

                x: Number(chartData[i][0]),

                y: null,

                ema1: (this.arr_ema1[i] != null ? Number(this.arr_ema1[i]) : null),

                ema2: (this.arr_ema2[i] != null ? Number(this.arr_ema2[i]) : null)

              });

              this.arr_signal[i] = 0;

            }

            this._exceptIdx[0]++;



            var signal_val = null;

            if (i >= this._emaNum2 + this._signal - 2) {

              signal_val = this.arr_signal[i];



              this._data2.push({

                x: Number(chartData[i][0]),

                y: Number(signal_val.toFixed(2)),

                macd: Number(macd)

              });

            } else {

              this._data2.push({

                x: Number(chartData[i][0]),

                y: null,

                macd: null

              });

            }

            this._exceptIdx[1]++;



            // osc 구하기

            if (macd != null && signal_val != null) {

              var osc = macd - signal_val,

                color = '';



              if (osc > 0) {

                color = Highcharts.getOptions().colors[9]

              } else {

                color = Highcharts.getOptions().colors[8]

              }



              this._data3.push({

                x: Number(chartData[i][0]),

                y: Number(osc.toFixed(2)),

                color: color

              });

            } else {

              this._data3.push({

                x: Number(chartData[i][0]),

                y: null,

                color: ''

              });

            }

            this._exceptIdx[2]++;

          } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

            this._data1.push({

              x: Number(chartData[i][0]),

              y: null,

              ema1: null,

              ema2: null

            });



            this._data2.push({

              x: Number(chartData[i][0]),

              y: null,

              macd: null

            });



            this._data3.push({

              x: Number(chartData[i][0]),

              y: null,

              color: ''

            });

          }

          // console.log(+i + "//" + chartData[i][6] + "//" + chartData[i][1] + "//" + chartData[i][2] + "//" + chartData[i][3] + "//" + chartData[i][4] + "//" + ema1 + "//" + ema2 + "//" + macd + "//" + signal);

        }

      }

    },

    /**

     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2015.07.22

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      var data_arr = [this._data1, this._data2, this._data3];

      for (var i = 0; i < 3; i++) {

        var data = data_arr[i];

        data[this._exceptIdx[i]][0] = nexUtils.date2Utc(datePoint);



        for (var j = this._exceptIdx[i] + 1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {

          if (interval == 'MINUTE' || interval == 'HOURS') {

            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

          } else {

            data[j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

          }

        }

      }

    },

    /**

     * desc : 한건의 데이터 추가

     * date : 2015.07.22

     * 

     * @param pointData : 한건의 데이터

     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) {



        this._data1.push({

          x: Number(pointData[0]),

          y: null,

          ema1: null,

          ema2: null

        });

        this._exceptIdx[0]++;



        this._data2.push({

          x: Number(pointData[0]),

          y: null,

          macd: null

        });

        this._exceptIdx[1]++;



        this._data3.push({

          x: Number(pointData[0]),

          y: null,

          color: ''

        });

        this._exceptIdx[2]++;

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2015.07.22

     * 

     * @param point : 업데이트될 위치(index)

     * @param pointData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     */

    updatePointData: function(point, chartData, exceptFlag) {

      if (chartData != null && chartData.length > 0) {

        if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

          exceptFlag = false;

        }



        var date_utc_time = chartData[point][0],

          factor1 = 2 / (this._emaNum1 + 1),

          factor2 = 2 / (this._emaNum2 + 1),

          factor3 = 2 / (this._signal + 1),

          macd = null;



        // emaNum1, emaNum2 에 대한 지수 이평선

        if (point >= 0) {

          if (point == 0) {

            this.arr_ema1[point] = chartData[point][4];

            this.arr_ema2[point] = chartData[point][4];

          } else {

            //this.arr_ema1[point] = chartData[point][4] * factor1 + (1 - factor1) * this.arr_ema1[point - 1]; // 지수이평

            this.arr_ema1[point] = nexChartUtils.calcSma(chartData,4,point,this._emaNum1); // 단순이평

            //this.arr_ema2[point] = chartData[point][4] * factor2 + (1 - factor2) * this.arr_ema2[point - 1]; // 지수이평

            this.arr_ema2[point] = nexChartUtils.calcSma(chartData,4,point,this._emaNum2); // 단순이평

          }

        }



        // MACD 구하기.

        if (point >= this._emaNum2 - 1) {

          macd = this.arr_ema1[point] - this.arr_ema2[point];



          this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = {

            x: Number(date_utc_time),

            y: Number(macd.toFixed(2)),

            ema1: Number(this.arr_ema1[point]),

            ema2: Number(this.arr_ema2[point])

          };



          // signal 구하기

          if (point == this._emaNum2 - 1) {

            this.arr_signal[point] = macd;

          } else {

            // this.arr_signal[point] = macd * factor3 + (1 - factor3) * this.arr_signal[point - 1]; // 지수이평

        	  this.arr_signal[point] = nexChartUtils.calcSma(this._data1,'y',point,this._signal); // 단순이평

          }



        } else {

          this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = {

            x: Number(date_utc_time),

            y: null,

            ema1: (this.arr_ema1[point] != null ? Number(this.arr_ema1[point]) : null),

            ema2: (this.arr_ema2[point] != null ? Number(this.arr_ema2[point]) : null)

          };

        }



        var signal_val = null;

        if (point >= this._emaNum2 + this._signal - 2) {

          signal_val = this.arr_signal[point];



          this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point] = {

            x: Number(date_utc_time),

            y: Number(signal_val.toFixed(2)),

            macd: Number(macd)

          };

        } else {

          this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point] = {

            x: Number(date_utc_time),

            y: null,

            macd: null

          };

        }



        // osc 구하기

        if (macd != null && signal_val != null) {

          var osc = macd - signal_val,

            color = '';

          if (osc > 0) {

            color = Highcharts.getOptions().colors[9]

          } else {

            color = Highcharts.getOptions().colors[8]

          }



          this._data3[exceptFlag ? (this._exceptIdx[2] - 1) : point] = {

            x: Number(date_utc_time),

            y: Number(osc.toFixed(2)),

            color: color

          };

        } else {

          this._data3[exceptFlag ? (this._exceptIdx[2] - 1) : point] = {

            x: Number(date_utc_time),

            y: null,

            color: ''

          };

        }

      }

    },

    /**

     * desc : 전체 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @return {Array}

     */

    getData: function(dataNum) {

      var data = [];

      if (dataNum == 1) {

        data = this._data1;

      } else if (dataNum == 2) {

        data = this._data2;

      } else if (dataNum == 3) {

        data = this._data3;

      }



      return data;

    },

    /**

     * desc : index 위치의 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param index : 위치

     * @return {Number}

     */

    getIndexData: function(dataNum, index) {

      var index_data = {};

      if (dataNum == 1) {

        index_data = this._data1[index];

      } else if (dataNum == 2) {

        index_data = this._data2[index];

      } else if (dataNum == 3) {

        index_data = this._data3[index];

      }



      return index_data;

    },

    /**

     * 차트별 마지막 데이터 복사하여 리턴.

     * @param dataNum

     * @param exceptFlag: 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     * @return {}

     */

    getCloneLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }



      var last_data = {},

        last_len = 0;



      if (dataNum == 1) {

        last_len = this._data1.length - 1;



        // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

        if (exceptFlag && this._exceptIdx[0] != 0) {

          last_len = this._exceptIdx[0] - 1;

        }



        last_data = {

          x: this._data1[last_len].x,

          y: this._data1[last_len].y,

          ema1: this._data1[last_len].ema1,

          ema2: this._data1[last_len].ema2

        };

      } else if (dataNum == 2) {

        last_len = this._data2.length - 1;



        // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

        if (exceptFlag && this._exceptIdx[1] != 0) {

          last_len = this._exceptIdx[1] - 1;

        }



        last_data = {

          x: this._data2[last_len].x,

          y: this._data2[last_len].y,

          macd: this._data2[last_len].macd

        };

      } else if (dataNum == 3) {

        last_len = this._data3.length - 1;



        // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

        if (exceptFlag && this._exceptIdx[2] != 0) {

          last_len = this._exceptIdx[2] - 1;

        }



        last_data = {

          x: this._data3[last_len].x,

          y: this._data3[last_len].y,

          color: this._data3[last_len].color

        };

      }



      return last_data;

    },

    /**

     * desc : 마지막 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param exceptflag : 빈데이터 제외 flag(true: 제외, false: 포함, default: true)

     * @return

     */

    getLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }



      var data = this.getData(dataNum),

        last_len = data.length - 1;



      // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

      if (exceptFlag && this._exceptIdx[dataNum - 1] != 0) {

        last_len = this._exceptIdx[dataNum - 1] - 1;

      }



      return data[last_len];

    },

    /**

     * desc : 빈데이터 시작 IDX 반환

     * date : 2015.07.22

     * 

     * @param : 가져올 데이터의 index

     * @return {Number}

     */

    getExceptIdx: function(dataNum) {

      var ret_idx = {};

      if (this._exceptIdx != null && this._exceptIdx.length > 0) {

        ret_idx = this._exceptIdx[dataNum - 1];

      }

      return ret_idx;

    }



  };



  /**

   * desc : stochastic slow 데이터 객체(slowstc)

   * date : 2015.07.22

   * 

   */

  var slowStcData = function(chart, seqId, chartData, day, slowK, slowD) {

	 this._chart = chart;

	 this._type = 'slowstc';

    this._id = seqId;

    this._data1 = []; // K

    this._data2 = []; // SLOW %K

    this._data3 = []; // SLOW %D

    this._day = day; // 기간

    this._slowK = slowK; // slow%K 입력값

    this._slowD = slowD; // slow%D 입력값

    this._exceptIdx = [];



    this.arr_slowK = [];

    this.arr_slowD = [];



    this.init();

    this.setData(chartData);



  }

  slowStcData.prototype = {

    init: function() {

      this._exceptIdx[0] = 0;

      this._exceptIdx[1] = 0;

      this._exceptIdx[2] = 0;



      this.arr_slowK = [];

      this.arr_slowD = [];

    },

    /**

     * desc : 타입 리턴

     * date : 2015.07.22

     * 

     * @return {String}

     */

    getType: function() {

      return this._type;

    },

    /**

     * desc: id 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getId: function() {

      return this._id;

    },

    /**

     * desc: 기간 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getDay: function() {

      return this._day;

    },

    /**

     * desc: slow%K 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getSlowK: function() {

      return this._slowK;

    },

    /**

     * desc: slow%D 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getSlowD: function() {

      return this._slowD;

    },

    /**

     * desc : 초기 전체 데이터 가공

     * date : 2015.07.22

     * 

     *

     * Stochastic Slow 계산식

     * K={(당일종가-최근 n일동안의 최저가)/(최근 n일동안의 최고가-최근 n일동안의 최저가)} * 100

     * %K= K를 n일간 지수이동평균한값

     * %D= %K를 n일간 지수이동평균한값

     *

     * @param chartData : 차트 데이터

     */

    setData: function(chartData) {

      if (chartData != null && chartData.length > 0) {

        for (var i = 0, len = chartData.length; i < len; i++) {

          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

            // K 구하기

            var toate_close_price = chartData[i][4];

            var dates_high_price = 0;

            var dates_Low_price = 0;

            var StcK = 0;

            

            if (i == 0) { // i = 0 일때

              dates_high_price = chartData[i][2];

              dates_Low_price = chartData[i][3];

            } else {

              if (i < this._day) { // i < 10 일때

                dates_high_price = Number(nexChartUtils.getHighMax(i, i + 1, chartData));

                dates_Low_price = Number(nexChartUtils.getLowMin(i, i + 1, chartData));

              } else { // i > 10 일때

                dates_high_price = Number(nexChartUtils.getHighMax(i, this._day, chartData));

                dates_Low_price = Number(nexChartUtils.getLowMin(i, this._day, chartData));

              }

            }



            if ((toate_close_price - dates_Low_price) == 0 && (dates_high_price - dates_Low_price) == 0) {

              StcK = 0;

            } else {

              StcK = Number((toate_close_price - dates_Low_price) / (dates_high_price - dates_Low_price) * 100);

            }



            this._data1.push([Number(chartData[i][0]), Number(StcK)]);

            this._exceptIdx[0]++;



            // %K 구하기

            if (i == 0) { // i가 0일때, 초기값은 StcK 값을 그대로 사용

              this.arr_slowK[i] = StcK;

            } else { // i가 0보다 클때

               //this.arr_slowK[i] = (StcK * (2 / (this._slowK + 1))) + this.arr_slowK[i - 1] * (1 - (2 / (this._slowK + 1))); // 지수이평

            	this.arr_slowK[i] = nexChartUtils.calcSma(this._data1,1,i,this._slowK); // 단순이평

            }



            var slowK = null;

            if (i >= this._slowK - 1) {

              slowK = this.arr_slowK[i];



              this._data2.push([Number(chartData[i][0]), Number(slowK.toFixed(2))]);

              this._exceptIdx[1]++;

            }



            // %D 구하기

            if (i == this._slowK - 1) { // i가 4일때, 초기값은 slowK 값을 그대로 사용

              this.arr_slowD[i] = slowK;

            } else { // i가 0보다 클때

            	//this.arr_slowD[i] = (this.arr_slowK[i] * (2 / (this._slowD + 1))) + this.arr_slowD[i - 1] * (1 - (2 / (this._slowD + 1)));

            	this.arr_slowD[i] = nexChartUtils.calcSma(this.arr_slowK, 0, i, this._slowD); // 단순이평

            }



            if (i >= this._slowK + this._slowD - 2) { // i가 10과 같거나 클때

              var slowD = this.arr_slowD[i];

              this._data3.push([Number(chartData[i][0]), Number(slowD.toFixed(2))]);

              this._exceptIdx[2]++;

            }

          } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

            this._data1.push([Number(chartData[i][0]), null]);

            this._data2.push([Number(chartData[i][0]), null]);

            this._data3.push([Number(chartData[i][0]), null]);



            this.arr_slowK[i] = 0;

            this.arr_slowD[i] = 0;

          }

           //console.log(i + "//" + chartData[i][6] + "//" + dates_high_price + "//" + dates_Low_price + "//" + StcK + "//" + slowK + "//" + slowD);

        } // for

      }

    },

    /**

     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2015.07.22

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      var data_arr = [this._data1, this._data2, this._data3];

      for (var i = 0; i < 3; i++) {

        var data = data_arr[i];

        data[this._exceptIdx[i]][0] = nexUtils.date2Utc(datePoint);



        for (var j = this._exceptIdx[i] + 1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {

          if (interval == 'MINUTE' || interval == 'HOURS') {

            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

          } else {

            data[j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

          }

        }

      }

    },

    /**

     * desc : 한건의 데이터 추가

     * date : 2015.07.22

     * 

     * @param pointData : 한건의 데이터

     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) {

        this._data1.push([Number(pointData[0]), null]);

        this._exceptIdx[0]++;

        this._data2.push([Number(pointData[0]), null]);

        this._exceptIdx[1]++;

        this._data3.push([Number(pointData[0]), null]);

        this._exceptIdx[2]++;

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2015.07.22

     * 

     * @param point : 업데이트될 위치(index)

     * @param pointData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     */

    updatePointData: function(point, chartData, exceptFlag) {

      if (chartData != null && chartData.length > 0) {

        if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

          exceptFlag = false;

        }

        var date_utc_time = chartData[point][0],

          toate_close_price = chartData[point][4],

          dates_high_price = chartData[point][2],

          dates_Low_price = chartData[point][3],

          StcK = 0;



        if (point == 0) { // i = 0 일때

          dates_high_price = chartData[point][2];

          dates_Low_price = chartData[point][3];

        } else {

          if (point < this._day) { // i < 10 일때

            dates_high_price = Number(nexChartUtils.getHighMax(point, point + 1, chartData));

            dates_Low_price = Number(nexChartUtils.getLowMin(point, point + 1, chartData));

          } else { // i > 10 일때

            dates_high_price = Number(nexChartUtils.getHighMax(point, this._day, chartData));

            dates_Low_price = Number(nexChartUtils.getLowMin(point, this._day, chartData));

          }

        }



        if ((toate_close_price - dates_Low_price) == 0 && (dates_high_price - dates_Low_price) == 0) {

          StcK = 0;

        } else {

          StcK = Number((toate_close_price - dates_Low_price) / (dates_high_price - dates_Low_price) * 100);

        }



        this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), Number(StcK)];



        // %K 구하기

        if (point == 0) { // i가 0일때, 초기값은 StcK 값을 그대로 사용

          this.arr_slowK[point] = StcK;

        } else { // i가 0보다 클때

          // this.arr_slowK[point] = (StcK * (2 / (this._slowK + 1))) + this.arr_slowK[point - 1] * (1 - (2 / (this._slowK + 1))); // 지수이평

        	this.arr_slowK[point] = nexChartUtils.calcSma(this._data1,1,point,this._slowK); // 단순이평

        }



        var slowK = null;

        if (point >= this._slowK - 1) {

          slowK = this.arr_slowK[point];

          this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point] = [Number(date_utc_time), Number(slowK.toFixed(2))];

        }



        // %D 구하기

        if (point == this._slowK - 1) { // i가 4일때, 초기값은 slowK 값을 그대로 사용

          this.arr_slowD[point] = slowK;

        } else { // i가 0보다 클때

          //this.arr_slowD[point] = (this.arr_slowK[point] * (2 / (this._slowD + 1))) + this.arr_slowD[point - 1] * (1 - (2 / (this._slowD + 1))); // 지수이평

          this.arr_slowD[point] = nexChartUtils.calcSma(this.arr_slowK,0,point,this._slowD); // 단순이평 // 단순이평

        }



        if (point >= this._slowK + this._slowD - 2) { // i가 10과 같거나 클때

          var slowD = this.arr_slowD[point];

          this._data3[exceptFlag ? (this._exceptIdx[2] - 1) : point] = [Number(date_utc_time), Number(slowD.toFixed(2))];

        }

      }

    },

    /**

     * desc : 전체 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @return {Array}

     */

    getData: function(dataNum) {

      var data = [];

      if (dataNum == 1) {

        data = this._data1;

      } else if (dataNum == 2) {

        data = this._data2;

      } else if (dataNum == 3) {

        data = this._data3;

      }

      return data;

    },

    /**

     * desc : index 위치의 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param index : 위치

     * @return {Number}

     */

    getIndexData: function(dataNum, index) {

      var data = [];

      if (dataNum == 1) {

        data = this._data1[index];

      } else if (dataNum == 2) {

        data = this._data2[index];

      } else if (dataNum == 3) {

        data = this._data3[index];

      }

      return data;

    },

    /**

     * desc : 마지막 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param exceptflag : 빈데이터 제외 flag(true: 제외, false: 포함, default: true)

     * @return

     */

    getLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }

      var data = this.getData(dataNum),

        last_len = data.length - 1;

      // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

      if (exceptFlag && this._exceptIdx[dataNum - 1] != 0) {

        last_len = this._exceptIdx[dataNum - 1] - 1;

      }

      return data[last_len];

    },

    /**

     * desc : 빈데이터 시작 IDX 반환

     * date : 2015.07.22

     * 

     * @param : 가져올 데이터의 index

     * @return {Number}

     */

    getExceptIdx: function(dataNum) {

      var ret_idx = {};

      if (this._exceptIdx != null && this._exceptIdx.length > 0) {

        ret_idx = this._exceptIdx[dataNum - 1];

      }

      return ret_idx;

    }

  };

  

  	/**

  	 * desc : stochastic fast 데이터 객체(faststc)

  	 * date : 2016.04.26

  	 */

    var fastStcData = function(chart, seqId, chartData, fastK, fastD) {

    	this._chart = chart;

    	this._type = 'faststc';

    	this._id = seqId;

    	this._data1 = []; // FAST %K

    	this._data2 = []; // FAST %D

    	this._fastK = fastK; // fast%K 입력값

    	this._fastD = fastD; // fast%D 입력값

    	this._exceptIdx = [];



    	this.arr_fastK = [];

    	this.arr_fastD = [];



    	this.init();

    	this.setData(chartData);

   	};

   	

   	fastStcData.prototype = {

	    init : function() {

			this._exceptIdx[0] = 0;

			this._exceptIdx[1] = 0;



			this.arr_fastK = [];

			this.arr_fastD = [];

		},

	    /**

		 * desc : 타입 리턴 

		 * date : 2016.04.26

		 * 

		 * @return {String}

		 */

		getType : function() {

			return this._type;

		},

	    /**

		 * desc: id 리턴

		 * date : 2016.04.26

		 * @return

		 */

		getId : function() {

			return this._id;

		},

		/**

		 * desc: fast%K 리턴

		 * date : 2016.04.26

		 * 

		 * @return

		 */

		getFastK : function() {

			return this._fastK;

		},

		/**

		 * desc: fast%D 리턴

		 * date : 2016.04.26

		 * 

		 * @return

		 */

		getFastD : function() {

			return this._fastD;

		},

	    /**

		 * desc : 초기 전체 데이터 가공 

		 * date : 2016.04.26

		 * 

		 * Stochastics Fast 계산식 

		 * %K={(당일종가-최근 n일동안의 최저가)/(최근 n일동안의 최고가-최근 n일동안의 최저가)} * 100 

		 * %D= %K를 n일간 지수이동평균한값 20160426 단순이평으로 변경(현업요청)

		 *

		 * @param chartData : 차트 데이터

		 */

		setData: function(chartData) {

			if (chartData != null && chartData.length > 0) {

				for (var i = 0, len = chartData.length; i < len; i++) {

					if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

						// K 구하기

						var toate_close_price = chartData[i][4];

						var dates_high_price = 0;

						var dates_Low_price = 0;

            

						if (i == 0) { // i = 0 일때

							dates_high_price = chartData[i][2];

							dates_Low_price = chartData[i][3];

						} else {

							if (i < this._fastK) { // i < 5 일때

								dates_high_price = Number(nexChartUtils.getHighMax(i, i + 1, chartData));

								dates_Low_price = Number(nexChartUtils.getLowMin(i, i + 1, chartData));

							} else { // i > 5 일때

								dates_high_price = Number(nexChartUtils.getHighMax(i, this._fastK, chartData));

								dates_Low_price = Number(nexChartUtils.getLowMin(i, this._fastK, chartData));

							}

						}

						

						// %K

						if ((toate_close_price - dates_Low_price) == 0 && (dates_high_price - dates_Low_price) == 0) {

							this.arr_fastK[i] = 0;

						} else {

							this.arr_fastK[i] = Number((toate_close_price - dates_Low_price) / (dates_high_price - dates_Low_price) * 100);

						}

						

						var fastK = this.arr_fastK[i];

						this._data1.push([Number(chartData[i][0]), Number(fastK.toFixed(2))]);

						this._exceptIdx[0]++;

						

						// %D

			            if(i == 0) {

			            	this.arr_fastD[i] = this.arr_fastK[i];

			            } else {

							//this.arr_fastD[i] = (this.arr_fastK[i] * (2 / (this._fastD + 1))) + this.arr_fastD[i - 1] * (1 - (2 / (this._fastD + 1)));

		            		  this.arr_fastD[i] = nexChartUtils.calcSma(this.arr_fastK,0,i,this._fastD);

			            }

						

						if(i >= this._fastD - 1) {

							this._data2.push([Number(chartData[i][0]), Number(this.arr_fastD[i].toFixed(2))]);

							this._exceptIdx[1]++;

						}

					} else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

						this._data1.push([Number(chartData[i][0]), null]);

						this._data2.push([Number(chartData[i][0]), null]);

						

						this.arr_fastK[i] = 0;

						this.arr_fastD[i] = 0;

					}

					//console.log(i + "//" + chartData[i][6] + "//" + dates_high_price + "//" + dates_Low_price + "//" + StcK + "//" + slowK + "//" + slowD);

				} // for

			}

		},

	    /**

	     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

		 * date : 2016.04.26

	     * 

	     * @param datePoint

	     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

	     * @param unit

	     */

		datePointChangeData: function(datePoint, interval, unit) {

	    	var data_arr = [ this._data1, this._data2 ];

			for (var i = 0; i < 2; i++) {

				var data = data_arr[i];

				data[this._exceptIdx[i]][0] = nexUtils.date2Utc(datePoint);



				for (var j = this._exceptIdx[i] + 1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {

					if (interval == 'MINUTE' || interval == 'HOURS') {

						data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

					} else {

						data[j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

					}

				}

			}

	    },

	    /**

	     * desc : 한건의 데이터 추가

		 * date : 2016.04.26

	     * 

	     * @param pointData : 한건의 데이터

	     */

	    addPointData : function(pointData) {

			if (pointData != null && pointData.length > 0) {

				this._data1.push([ Number(pointData[0]), null ]);

				this._exceptIdx[0]++;

				this._data2.push([ Number(pointData[0]), null ]);

				this._exceptIdx[1]++;

			}

		},

	    /**

		 * desc : 한건의 데이터 수정 

		 * date : 2016.04.26

		 * 

		 * @param point : 업데이트될 위치(index)

		 * @param pointData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

		 * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

		 */

	    updatePointData: function(point, chartData, exceptFlag) {

	    	if (chartData != null && chartData.length > 0) {

    	        if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

    	          exceptFlag = false;

    	        }

    	        var date_utc_time = chartData[point][0];

	    		var toate_close_price = chartData[point][4];

				var dates_high_price = chartData[point][2];

				var dates_Low_price = chartData[point][3];

				

				if (point == 0) { // i = 0 일때

					dates_high_price = chartData[point][2];

					dates_Low_price = chartData[point][3];

				} else {

					if (point < this._fastK) { // i < 5 일때

						dates_high_price = Number(nexChartUtils.getHighMax(point, point + 1, chartData));

						dates_Low_price = Number(nexChartUtils.getLowMin(point, point + 1, chartData));

					} else { // i > 5 일때

						dates_high_price = Number(nexChartUtils.getHighMax(point, this._fastK, chartData));

						dates_Low_price = Number(nexChartUtils.getLowMin(point, this._fastK, chartData));

					}

				}

				

				// %K

				if ((toate_close_price - dates_Low_price) == 0 && (dates_high_price - dates_Low_price) == 0) {

					this.arr_fastK[point] = 0;

				} else {

					this.arr_fastK[point] = Number((toate_close_price - dates_Low_price) / (dates_high_price - dates_Low_price) * 100);

				}

				

				var fastK = this.arr_fastK[point];

				this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = ([Number(date_utc_time), Number(fastK.toFixed(2))]);

				

				// %D

	            if(point == 0) {

	            	this.arr_fastD[point] = this.arr_fastK[point];

	            } else {

            		this.arr_fastD[point] = nexChartUtils.calcSma(this.arr_fastK,0,point,this._fastD);

	            }

				

				if(point >= this._fastD - 1) {

					this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point] = ([Number(date_utc_time), Number(this.arr_fastD[point].toFixed(2))]);

				}

	    	}

	    },

	    /**

	     * desc : 전체 데이터 반환

		 * date : 2016.04.26

	     * 

	     * @param dataNum : 가져올 데이터의 index

	     * @return {Array}

	     */

	    getData: function(dataNum) {

	    	if (dataNum == 1) {

	    		return this._data1;

	    	} else if (dataNum == 2) {

	    		return this._data2;

	    	} 

	    },

	    /**

	     * desc : index 위치의 데이터 반환

		 * date : 2016.04.26

	     * 

	     * @param dataNum : 가져올 데이터의 index

	     * @param index : 위치

	     * @return {Number}

	     */

	    getIndexData : function(dataNum, index) {

			if (dataNum == 1) {

				return this._data1[index];

			} else if (dataNum == 2) {

				return this._data2[index];

			}

		},

	    /**

		 * desc : 마지막 데이터 반환 

		 * date : 2016.04.26

		 * 

		 * @param dataNum : 가져올 데이터의 index

		 * @param exceptflag : 빈데이터 제외 flag(true: 제외, false: 포함, default: true)

		 * @return

		 */

	    getLastData : function(dataNum, exceptFlag) {

			if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

				exceptFlag = true;

			}

			var data = this.getData(dataNum), last_len = data.length - 1;

			// 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

			if (exceptFlag && this._exceptIdx[dataNum - 1] != 0) {

				last_len = this._exceptIdx[dataNum - 1] - 1;

			}

			return data[last_len];

		},

	    /**

		 * desc : 빈데이터 시작 IDX 반환 

		 * date : 2016.04.26

		 * 

		 * @param : 가져올 데이터의 index

		 * 

		 * @return {Number}

		 */

		getExceptIdx: function(dataNum) {

			var ret_idx = {};

			if (this._exceptIdx != null && this._exceptIdx.length > 0) {

				ret_idx = this._exceptIdx[dataNum - 1];

			}

			return ret_idx;

		}

   	};



  /**

   * desc : cci slow 데이터 객체(cci)

   * date : 2015.07.22

   * 

   */

  var cciData = function(chart, seqId, chartData, day, signal) {

	 this._chart = chart;

	 this._type = 'cci';

    this._id = seqId;

    this._data1 = []; // cci 평균가격

    this._data2 = []; // cci 이동평균가격

    this._data3 = []; // cci

    this._data4 = []; // cci 시그널선

    this._day = day; // 기간

    this._signal = signal; // 시그널



    this._exceptIdx = [];



    this.arr_cci = [];

    this.arr_cciabs = [];

    this.arr_signal = [];



    this.init();

    this.setData(chartData);

  }

  cciData.prototype = {

    init: function() {

      this._exceptIdx[0] = 0;

      this._exceptIdx[1] = 0;

      this._exceptIdx[2] = 0;

      this._exceptIdx[3] = 0;



      this.arr_cciabs = [];

      this.arr_cci = [];

      this.arr_signal = [];

    },

    /**

     * desc : 타입 리턴

     * date : 2015.07.22

     * 

     * @return {String}

     */

    getType: function() {

      return this._type;

    },

    /**

     * desc: id 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getId: function() {

      return this._id;

    },

    /**

     * desc: 기간 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getDay: function() {

      return this._day;

    },

    /**

     * desc : 초기 전체 데이터 가공

     * date : 2015.07.22

     * 

     *

     * CCI (Commodity Channel Index) 계산식

     * CCI = (X-Y)/ (Z * 0.015) (기본설정값 : 14일)

     * X: (고가+저가+종가)/3

     * Y: X의 n일 단순이동평균값

     * Z: ∑|(X-Y)| / n

     *    - |X-Y|0, |X-Y|1, |X-Y|3,....., |X-Y|i .... 에 대한 n일 평균값

     *    - |X-Y|i: X는 i ~ i+N-1까지, Y는 i+N-1번째 값 고정

     *

     * @param chartData : 차트 데이터

     */

    setData: function(chartData) {

      if (chartData != null && chartData.length > 0) {

        for (var i = 0, len = chartData.length; i < len; i++) {

          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

            // cci의 평균가격 구하기 (고가+저가+종가)/3

            var cci_avg = Number((chartData[i][2] + chartData[i][3] + chartData[i][4]) / 3);



            this._data1.push([Number(chartData[i][0]), cci_avg]);

            this._exceptIdx[0]++;



            //cci의 평균가격에 대한 n일 이동평균 구하기.

            var cci_sma = null;

            if ((i - this._day) + 1 >= 0) {

              cci_sma = 0;

              for (var j = 0; j < this._day; j++) {

                cci_sma += this._data1[i - j][1];

              }

              cci_sma = Number(cci_sma / this._day);

            }



            this._data2.push([Number(chartData[i][0]), cci_sma]);

            this._exceptIdx[1]++;



            // cci 계산하기

            var cci_val = null,

              cciabs = 0;



            if (i >= this._day - 1) {

              for (var j = i - this._day + 1; j <= i; j++) {

                cciabs += Math.abs(this._data1[j][1] - this._data2[i][1]);

              }

              this.arr_cciabs[i] = cciabs / this._day;

              cci_val = Number(((this._data1[i][1] - this._data2[i][1]) / (this.arr_cciabs[i] * 0.015)).toFixed(2));

            }

            this.arr_cci[i] = cci_val;

            this._data3.push([Number(chartData[i][0]), cci_val]);

            this._exceptIdx[2]++;



            // 시그널선 계산

            var signal_day = this._signal;

            if (i == this._day - 1) { // i가 13 일때, 초기값은 cci_val 값을 그대로 사용

              this.arr_signal[i] = cci_val;

            } else { // i가 10 보다 클때

              //this.arr_signal[i] = (cci_val * (2 / (signal_day + 1))) + this.arr_signal[i - 1] * (1 - (2 / (signal_day + 1)));

              this.arr_signal[i] = nexChartUtils.calcSma(this.arr_cci,0,i,signal_day);

            }



            if (i >= this._day + signal_day - 2) { // i가 21 또는 21 보다 클때

              var signal_val = this.arr_signal[i];

              this._data4.push([Number(chartData[i][0]), Number(signal_val.toFixed(2))]);

              this._exceptIdx[3]++;

            }

          } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

            this._data1.push([Number(chartData[i][0]), null]);

            this._data2.push([Number(chartData[i][0]), null]);

            this._data3.push([Number(chartData[i][0]), null]);

            this._data4.push([Number(chartData[i][0]), null]);



            this.arr_cciabs[i] = 0;

            this.arr_signal[i] = 0;

          }

          /*console.log( i + "//"

            + chartData[i][6] + "//" + chartData[i][1] + "//" + chartData[i][2] + "//" + chartData[i][3] + "//" + chartData[i][4] + "//"

            + cci_avg + "//" + cci_sma + "//" + cci_val );

            */

        }

      }

    },

    /**

     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2015.07.22

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      var data_arr = [this._data1, this._data2, this._data3, this._data4];

      for (var i = 0; i < 4; i++) {

        var data = data_arr[i];

        data[this._exceptIdx[i]][0] = nexUtils.date2Utc(datePoint);



        for (var j = this._exceptIdx[i] + 1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {

          if (interval == 'MINUTE' || interval == 'HOURS') {

            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

          } else {

            data[j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

          }

        }

      }

    },

    /**

     * desc : 한건의 데이터 추가

     * date : 2015.07.22

     * 

     * @param pointData : 한건의 데이터

     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) { // 빈데이터 추가

        this._data1.push([Number(pointData[0]), null]);

        this._exceptIdx[0]++;

        this._data2.push([Number(pointData[0]), null]);

        this._exceptIdx[1]++;

        this._data3.push([Number(pointData[0]), null]);

        this._exceptIdx[2]++;

        this._data4.push([Number(pointData[0]), null]);

        this._exceptIdx[3]++;

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2015.07.22

     * 

     * @param point : 업데이트될 위치(index)

     * @param pointData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     */

    updatePointData: function(point, chartData, exceptFlag) {

      if (chartData != null && chartData.length > 0) {

        if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

          exceptFlag = false;

        }



        var date_utc_time = chartData[point][0],

          cci_avg = Number((chartData[point][2] + chartData[point][3] + chartData[point][4]) / 3); // cci의 평균가격 구하기 (고가+저가+종가)/3



        this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), cci_avg];



        //cci의 평균가격에 대한 n일 이동평균 구하기.

        var cci_sma = null;

        if ((point - this._day) + 1 >= 0) {

          cci_sma = 0;

          for (var j = 0; j < this._day; j++) {

            cci_sma += this._data1[point - j][1];

          }



          cci_sma = Number(cci_sma / this._day);

        }



        this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point] = [Number(date_utc_time), cci_sma];



        // cci 계산하기

        var cci_val = null,

          cciabs = 0;



        if (point >= this._day - 1) {

          for (var j = (exceptFlag ? (this._exceptIdx[0] - 1) : point) - this._day + 1; j <= (exceptFlag ? (this._exceptIdx[0] - 1) : point); j++) {

            cciabs += Math.abs(this._data1[j][1] - this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point][1]);

          }

          this.arr_cciabs[point] = cciabs / this._day;

          cci_val = Number(((this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point][1] - this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point][1]) / (this.arr_cciabs[exceptFlag ? (this._exceptIdx[1] - 1) : point] * 0.015)).toFixed(2));

        }

        

        this.arr_cci[exceptFlag ? (this._exceptIdx[2] - 1) : point] = cci_val;

        this._data3[exceptFlag ? (this._exceptIdx[2] - 1) : point] = [Number(date_utc_time), cci_val];



        // 시그널선 계산

        var signal_day = this._signal;

        if (point == this._day - 1) { // i가 13 일때, 초기값은 cci_val 값을 그대로 사용

          this.arr_signal[point] = cci_val;

        } else { // i가 10 보다 클때

          //this.arr_signal[point] = (cci_val * (2 / (signal_day + 1))) + this.arr_signal[point - 1] * (1 - (2 / (signal_day + 1)));

          this.arr_signal[point] = this.arr_signal[point] = nexChartUtils.calcSma(this.arr_cci,0,point,signal_day);

        }



        if (point >= this._day + signal_day - 2) { // i가 21 또는 21 보다 클때

          var signal_val = this.arr_signal[point];

          this._data4[exceptFlag ? (this._exceptIdx[3] - 1) : point] = [Number(date_utc_time), Number(signal_val.toFixed(2))];

        }

      }

    },

    /**

     * desc : 전체 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @return {Array}

     */

    getData: function(dataNum) {

      if (dataNum == 1) {

        return this._data1;

      } else if (dataNum == 2) {

        return this._data2;

      } else if (dataNum == 3) {

        return this._data3;

      } else if (dataNum == 4) {

        return this._data4;

      }

      return this._data1;

    },

    /**

     * desc : index 위치의 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param index : 위치

     * @return {Number}

     */

    getIndexData: function(dataNum, index) {

      var data = [];

      if (dataNum == 1) {

        data = this._data1[index];

      } else if (dataNum == 2) {

        data = this._data2[index];

      } else if (dataNum == 3) {

        data = this._data3[index];

      } else if (dataNum == 4) {

        data = this._data4[index];

      }

      return data;

    },

    /**

     * desc : 마지막 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param exceptflag : 빈데이터 제외 flag(true: 제외, false: 포함, default: true)

     * @return

     */

    getLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }

      var data = this.getData(dataNum),

        last_len = data.length - 1;

      // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

      if (exceptFlag && this._exceptIdx[dataNum - 1] != 0) {

        last_len = this._exceptIdx[dataNum - 1] - 1;

      }

      return data[last_len];

    },



    /**

     * desc : 빈데이터 시작 IDX 반환

     * date : 2015.07.22

     * 

     * @param : 가져올 데이터의 index

     * @return {Number}

     */

    getExceptIdx: function(dataNum) {

      return this._exceptIdx[dataNum - 1];

    }



  };



  	/**

	 * desc : 투자심리 데이터 객체(mental) 

	 * date : 2015.07.22

	 */

  	var mentalData = function(chart, seqId, chartData, day, signal) {

		this._chart = chart;

		this._type = 'mental';

		this._id = seqId;

		this._data1 = []; // 심리도선(mental)

		this._data2 = []; // 시그널선

		this._day = day; // 기간

		this._signal = signal; // 시그널



		this._exceptIdx = [];



		this.arr_mental = [];

		this.arr_signal = [];



		this.init();

		this.setData(chartData);

	};

  	mentalData.prototype = {

	    init : function() {

			this._exceptIdx[0] = 0;

			this._exceptIdx[1] = 0;

			

			this.arr_mental = [];

			this.arr_signal = [];

		},

		/**

		 * desc : 타입 리턴 date : 2015.07.22

		 * 

		 * @return {String}

		 */

		getType: function() {

			return this._type;

		},

	    /**

	     * desc: id 리턴

	     * date : 2015.07.22

	     * 

	     * @return

	     */

	    getId: function() {

	    	return this._id;

		    },

	    /**

	     * desc: 기간 리턴

	     * date : 2015.07.22

	     * 

	     * @return

	     */

	    getDay: function() {

	    	return this._day;

	    },

	    /**

	     * desc : 초기 전체 데이터 가공

	     * date : 2015.07.22

	     *

	     * 심리도 계산식

	     * 심리도(mental) = (n일간 전일대비 상승일수 / n) * 100

	     * @param chartData : 차트 데이터

	     */

	    setData: function(chartData) {

	    	if (chartData != null && chartData.length > 0) {

	    		for (var i = 0, len = chartData.length; i < len; i++) {

	    			if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

	    				var upDate = 0;

	

	    				// 전일대비 상승일 수 계산

	    				for (var j = 0; j < this._day; j++) {

	    					if (i - j - 1 >= 0) {

	    						if (chartData[i - j][4] > chartData[i - j - 1][4]) {

	    							upDate++;

	    						}

	    					}

	    				}

	

	    				if (i >= this._day) { // i가 10 또는 10 보다 클때

	    					var mental = (upDate / this._day) * 100; // 심리도 계산

	    					

	    					this.arr_mental[i] = mental;

	    					this._data1.push([Number(chartData[i][0]), mental]);

	    					this._exceptIdx[0]++;

	

	    					// 시그널선 계산

	    					var signal_day = this._signal;

	    					if (i == this._day) { // i가 10 일때, 초기값은 mental 값을 그대로 사용

	    						this.arr_signal[i] = mental;

	    					} else { // i가 10 보다 클때

	    						//this.arr_signal[i] = (mental * (2 / (signal_day + 1))) + this.arr_signal[i - 1] * (1 - (2 / (signal_day + 1)));

	    						this.arr_signal[i] = nexChartUtils.calcSma(this.arr_mental, 0, i, signal_day);

	    					}

	

	    					if (i >= this._day + signal_day - 1) { // i가 24 또는 24 보다 클때

	    						var signal_val = this.arr_signal[i];

	    						this._data2.push([Number(chartData[i][0]), Number(signal_val.toFixed(2))]);

	    						this._exceptIdx[1]++;

	    					}

	    				}

	    			} else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

	    				this._data1.push([Number(chartData[i][0]), null]);

	    				this._data2.push([Number(chartData[i][0]), null]);

	    				this.arr_signal[i] = 0;

	    			}

	    			//console.log( + i + "//" + chartData[i][6] + "//" + mental + "//" + signal_val );

	    		}

	    	}

	    },

	    /**

	     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

	     * date : 2015.07.22

	     * 

	     * @param datePoint

	     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

	     * @param unit

	     */

	    datePointChangeData: function(datePoint, interval, unit) {

	    	var data_arr = [ this._data1, this._data2 ];

			for (var i = 0; i < 2; i++) {

				var data = data_arr[i];

				data[this._exceptIdx[i]][0] = nexUtils.date2Utc(datePoint);



				for (var j = this._exceptIdx[i] + 1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {

					if (interval == 'MINUTE' || interval == 'HOURS') {

						data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

					} else {

						data[j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

					}

				}

			}

	    },

	    /**

	     * desc : 한건의 데이터 추가

	     * date : 2015.07.22

	     * 

	     * @param pointData : 한건의 데이터

	     */

	    addPointData: function(pointData) {

	    	if (pointData != null && pointData.length > 0) { // 빈데이터 추가

	    		this._data1.push([Number(pointData[0]), null]);

	    		this._exceptIdx[0]++;

	    		this._data2.push([Number(pointData[0]), null]);

	    		this._exceptIdx[1]++;

	    	}

	    },

	    /**

	     * desc : 한건의 데이터 수정

	     * date : 2015.07.22

	     * 

	     * @param point : 업데이트될 위치(index)

	     * @param pointData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

	     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

	     */

	    updatePointData: function(point, chartData, exceptFlag) {

	    	if (chartData != null && chartData.length > 0) {

	    		if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

	    			exceptFlag = false;

	    		}

	

	    		var date_utc_time = chartData[point][0];

	    		var upDate = 0;

	

	    		// 전일대비 상승일 수 계산

	    		for (var j = 0; j < this._day; j++) {

	    			if (point - j - 1 >= 0) {

	    				if (chartData[point - j][4] > chartData[point - j - 1][4]) {

	    					upDate++;

	    				}

	    			}

	    		}

	

	    		if (point >= this._day) { // i가 10 또는 10 보다 클때

	    			var mental = (upDate / this._day) * 100; // 심리도 계산

	    			this.arr_mental[exceptFlag ? (this._exceptIdx[0] - 1) : point] = mental;

	    			this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), mental];

	

	    			// 시그널선 계산

	    			var signal_day = this._signal; 

	    			if (point == this._day) { // i가 10 일때, 초기값은 mental 값을 그대로 사용

	    				this.arr_signal[point] = mental;

	    			} else { // i가 10 보다 클때

	    				// this.arr_signal[point] = (mental * (2 / (signal_day + 1))) + this.arr_signal[point - 1] * (1 - (2 / (signal_day + 1)));

	    				this.arr_signal[point] = nexChartUtils.calcSma(this.arr_mental, 0, point, signal_day);

	    			}

	

	    			if (point >= this._day + signal_day - 1) { // i가 24 또는 24 보다 클때

	    				var signal_val = this.arr_signal[point];

	    				this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point] = [Number(date_utc_time), Number(signal_val.toFixed(2))];

	    			}

	    		}

	    	}

	    },

	    //전체 데이터 리턴.

	    getData: function(dataNum) {

	    	var data = [];

	    	if (dataNum == 1) {

	    		data = this._data1;

	    	} else if (dataNum == 2) {

	    		data = this._data2;

	    	}

	    	return data;

	    },

	    /**

	     * desc : index 위치의 데이터 반환

	     * date : 2015.07.22

	     * 

	     * @param dataNum : 가져올 데이터의 index

	     * @param index : 위치

	     * @return {Number}

	     */

	    getIndexData: function(dataNum, index) {

	    	var data = [];

	    	if (dataNum == 1) {

	    		data = this._data1[index];

	    	} else if (dataNum == 2) {

	    		data = this._data2[index];

	    	}

	    	return data;

	    },

	    /**

	     * desc : 마지막 데이터 반환

	     * date : 2015.07.22

	     * 

	     * @param dataNum : 가져올 데이터의 index

	     * @param exceptflag : 빈데이터 제외 flag(true: 제외, false: 포함, default: true)

	     * @return

	     */

	    getLastData: function(dataNum, exceptFlag) {

	    	if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

	    		exceptFlag = true;

	    	}

	    	var data = this.getData(dataNum),

	    	last_len = data.length - 1;

	    	// 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

	    	if (exceptFlag && this._exceptIdx[dataNum - 1] != 0) {

	    		last_len = this._exceptIdx[dataNum - 1] - 1;

	    	}

	    	return data[last_len];

	    },

	    /**

	     * desc : 빈데이터 시작 IDX 반환

	     * date : 2015.07.22

	     * 

	     * @param : 가져올 데이터의 index

	     * @return {Number}

	     */

	    getExceptIdx: function(dataNum) {

	    	return this._exceptIdx[dataNum - 1];

	    }

  	};



  /**

   * desc : adx 데이터 객체(adx)

   * date : 2015.07.22

   * 

   */

  var adxData = function(chart, seqId, chartData, day) {

	 this._chart = chart;

	 this._type = 'adx';

    this._id = seqId;

    this._data1 = []; // pdi

    this._data2 = []; // mdi

    this._data3 = []; // adx

    this._day = day; // 기간



    this._exceptIdx = [];



    this.arr_ema_pdi = [];

    this.arr_ema_mdi = [];

    this.arr_ema_tr = [];

    this.arr_pdm = [];

    this.arr_mdm = [];

    this.arr_tr = [];

    this.arr_dx = [];

    this.arr_Adx = [];



    this.init();

    this.setData(chartData);

  }

  adxData.prototype = {

    init: function() {

      this._exceptIdx[0] = 0;

      this._exceptIdx[1] = 0;

      this._exceptIdx[2] = 0;



      this.arr_ema_pdi = [];

      this.arr_ema_mdi = [];

      this.arr_ema_tr = [];

      this.arr_pdm = [];

      this.arr_mdm = [];

      this.arr_tr = [];

      this.arr_dx = [];

      this.arr_Adx = [];

    },

    /**

     * desc : 타입 리턴

     * date : 2015.07.22

     * 

     * @return {String}

     */

    getType: function() {

      return this._type;

    },

    /**

     * desc: id 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getId: function() {

      return this._id;

    },

    /**

     * desc: 기간 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getDay: function() {

      return this._day;

    },

    /**

     * desc : 초기 전체 데이터 가공

     * date : 2015.07.22

     * 

     *

     * ADX (Average Directional Movement Index) 계산식

     * DX = [{(PDI) - (MDI)}의 절대값 / {(PDI)+(MDI)}] ×100

     * DX의 n일 지수이동평균(14일)

     * EMA (지수이동평균) = C * K +Xp(1-K) (C : 당일치, Xp : 전일이동평균, K(exponential percentage)=2/(n+1))

     *

     * @param chartData : 차트 데이터

     */

    setData: function(chartData) {

      if (chartData != null && chartData.length > 0) {

        //var K = 2 / (this._day + 1);

        for (var i = 1, len = chartData.length; i < len; i++) {

          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {



            var temp_pdm1 = Number(chartData[i][2]) - Number(chartData[i - 1][2]); // 당일고가 - 전일고가

            var temp_pdm2 = Number(chartData[i - 1][3]) - Number(chartData[i][3]); // 전일저가 - 당일저가



            // pdm

            if (temp_pdm1 > 0 && temp_pdm1 > temp_pdm2) {

            	this.arr_ema_pdi[i] = temp_pdm1;

            } else {

            	this.arr_ema_pdi[i] = 0;

            }



            // mdm

            if (temp_pdm2 > 0 && temp_pdm1 < temp_pdm2) {

            	this.arr_ema_mdi[i] = temp_pdm2;

            } else {

            	this.arr_ema_mdi[i] = 0;

            }

            

            //tr

            var temp_pdi1 = (Number(chartData[i][2]) - Number(chartData[i][3])); // 당일고가 - 당일저가

            var temp_pdi2 = Math.abs(Number(chartData[i - 1][4]) - Number(chartData[i][2])); // 전일종가 - 당일고가

            var temp_pdi3 = Math.abs(Number(chartData[i - 1][4]) - Number(chartData[i][3])); // 전일종가 - 당일저가

            this.arr_ema_tr[i] = Math.max(temp_pdi1, temp_pdi2, temp_pdi3); // TR

           

            /*

            if (i == 1) { // 2016.04.28 현업요청: 단순이평으로 처리

              this.arr_ema_pdi[i] = Number(pdm * K); // pdm n일 지수이동평균

              this.arr_ema_mdi[i] = Number(mdm * K); // mdm n일 지수이동평균

              this.arr_ema_tr[i] = Number(tr * K); // tr n일 지수이동평균

            } else {

              this.arr_ema_pdi[i] = Number(pdm * K + this.arr_ema_pdi[i - 1] * (1 - K)); // pdm n일 지수이동평균

              this.arr_ema_mdi[i] = Number(mdm * K + this.arr_ema_mdi[i - 1] * (1 - K)); // mdm n일 지수이동평균

              this.arr_ema_tr[i] = Number(tr * K + this.arr_ema_tr[i - 1] * (1 - K)); // tr n일 지수이동평균

            }*/

            if (i == 1) {

            	this.arr_pdm[i] = this.arr_ema_pdi[i];

        		this.arr_mdm[i] = this.arr_ema_pdi[i];

        		this.arr_tr[i] = this.arr_ema_pdi[i];

            } else {

            	this.arr_pdm[i] = nexChartUtils.calcSma(this.arr_ema_pdi,0,i,this._day); // 단순이평

        		this.arr_mdm[i] = nexChartUtils.calcSma(this.arr_ema_mdi,0,i,this._day); // 단순이평

        		this.arr_tr[i] = nexChartUtils.calcSma(this.arr_ema_tr,0,i,this._day); // 단순이평

            }



            // PDI, MDI 계산

            var pdi = Number(this.arr_pdm[i]) / Number(this.arr_tr[i]) * 100;

            var mdi = Number(this.arr_mdm[i]) / Number(this.arr_tr[i]) * 100;

            var temp_pdi4 = Math.abs(pdi - mdi);

            var temp_mdi4 = pdi + mdi;

            var dx = (temp_pdi4 / temp_mdi4) * 100;

            this.arr_dx[i] = dx;

            

            if (i >= this._day - 1) {

              this._data1.push([Number(chartData[i][0]), Number(pdi.toFixed(2))]);

              this._exceptIdx[0]++;

              this._data2.push([Number(chartData[i][0]), Number(mdi.toFixed(2))]);

              this._exceptIdx[1]++;

            }



            // ADX 계산

            if (i >= this._day) {

              if (i == this._day) {

                //this.arr_Adx[i] = Number(dx * K); // dx n일 지수이동평균 (전일값 =0)

            	this.arr_Adx[i] = dx;//nexChartUtils.calcSma(this.arr_dx,0,i,this._day); // 단순이평

              } else {

                //this.arr_Adx[i] = Number(dx * K + this.arr_Adx[i - 1] * (1 - K)); // dx n일 지수이동평균

            	this.arr_Adx[i] = nexChartUtils.calcSma(this.arr_dx,0,i,this._day); // 단순이평

              }



              var valAdx = this.arr_Adx[i];

              this._data3.push([Number(chartData[i][0]), Number(valAdx.toFixed(2))]);

              this._exceptIdx[2]++;

            }

          } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

            this._data1.push([Number(chartData[i][0]), null]);

            this._data2.push([Number(chartData[i][0]), null])

            this._data3.push([Number(chartData[i][0]), null]);

          }

          // console.log( + i + "//" + chartData[i][6] + "//" + temp_pdm + "//" + temp_mdm + "//" + temp_tr + "//" + pdm + "//" + mdm + "//" + tr + "//" + ema_pdi + "//" + ema_mdi + "//" + ema_tr + "//" + pdi + "//" + mdi + "//" + dx + "//" + valAdx );

        } // for

      }

    },

    /**

     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2015.07.22

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      var data_arr = [this._data1, this._data2, this._data3];

      for (var i = 0; i < 3; i++) {

        var data = data_arr[i];

        data[this._exceptIdx[i]][0] = nexUtils.date2Utc(datePoint);



        for (var j = this._exceptIdx[i] + 1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {

          if (interval == 'MINUTE' || interval == 'HOURS') {

            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

          } else {

            data[j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

          }

        }

      }

    },

    /**

     * desc : 한건의 데이터 추가

     * date : 2015.07.22

     * 

     * @param pointData : 한건의 데이터

     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) { // 빈데이터 추가

        this._data1.push([Number(pointData[0]), null]);

        this._exceptIdx[0]++;

        this._data2.push([Number(pointData[0]), null]);

        this._exceptIdx[1]++;

        this._data3.push([Number(pointData[0]), null]);

        this._exceptIdx[2]++;

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2015.07.22

     * 

     * @param point : 업데이트될 위치(index)

     * @param pointData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     */

    updatePointData: function(point, chartData, exceptFlag) {

      if (chartData != null && chartData.length > 0) {

        if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

          exceptFlag = false;

        }



        //var K = 2 / (this._day + 1);

        var date_utc_time = chartData[point][0];

        var temp_pdm1 = Number(chartData[point][2]) - Number(chartData[point - 1][2]); // 당일고가 - 전일고가

        var temp_pdm2 = Number(chartData[point - 1][3]) - Number(chartData[point][3]); // 전일저가 - 당일저가



        if (temp_pdm1 > 0 && temp_pdm1 > temp_pdm2) {

        	this.arr_ema_pdi[point] = temp_pdm1;

        } else{

        	this.arr_ema_pdi[point] = 0;

        }



        if (temp_pdm2 > 0 && temp_pdm1 < temp_pdm2) {

        	this.arr_ema_mdi[point] = temp_pdm2;

        } else {

        	this.arr_ema_mdi[point] = 0;

        }



        var temp_pdi1 = (Number(chartData[point][2]) - Number(chartData[point][3])); // 당일고가 - 당일저가

        var temp_pdi2 = Math.abs(Number(chartData[point - 1][4]) - Number(chartData[point][2])); // 전일종가 - 당일고가

        var temp_pdi3 = Math.abs(Number(chartData[point - 1][4]) - Number(chartData[point][3])); // 전일종가 - 당일저가

        var tr = Math.max(temp_pdi1, temp_pdi2, temp_pdi3); // TR

        this.arr_ema_tr[point] = tr;

        

        /*if (point == 1) {

          this.arr_ema_pdi[point] = Number(pdm * K); // pdm n일 지수이동평균

          this.arr_ema_mdi[point] = Number(mdm * K); // mdm n일 지수이동평균

          this.arr_ema_tr[point] = Number(tr * K); // tr n일 지수이동평균

        } else {

          this.arr_ema_pdi[point] = Number(pdm * K + this.arr_ema_pdi[point - 1] * (1 - K)); // pdm n일 지수이동평균

          this.arr_ema_mdi[point] = Number(mdm * K + this.arr_ema_mdi[point - 1] * (1 - K)); // mdm n일 지수이동평균

          this.arr_ema_tr[point] = Number(tr * K + this.arr_ema_tr[point - 1] * (1 - K)); // tr n일 지수이동평균

        }*/

        if (point == 1) {

        	this.arr_pdm[point] = this.arr_ema_pdi[point];

    		this.arr_mdm[point] = this.arr_ema_pdi[point];

    		this.arr_tr[point] = this.arr_ema_pdi[point];

        } else {

        	this.arr_pdm[point] = nexChartUtils.calcSma(this.arr_ema_pdi,0,point,this._day); // 단순이평

    		this.arr_mdm[point] = nexChartUtils.calcSma(this.arr_ema_mdi,0,point,this._day); // 단순이평

    		this.arr_tr[point] = nexChartUtils.calcSma(this.arr_ema_tr,0,point,this._day); // 단순이평

        }



        // PDI, MDI 계산

        var pdi = Number(this.arr_pdm[point]) / Number(this.arr_tr[point]) * 100,

          mdi = Number(this.arr_mdm[point]) / Number(this.arr_tr[point]) * 100,

          temp_pdi4 = Math.abs(pdi - mdi),

          temp_mdi4 = pdi + mdi;



        var dx = (temp_pdi4 / temp_mdi4) * 100;

        this.arr_dx[point] = dx;

        if (point >= this._day - 1) {

          this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), Number(pdi.toFixed(2))];

          this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point] = [Number(date_utc_time), Number(mdi.toFixed(2))];

        }



        // ADX 계산

        if (point >= this._day) {

          if (point == this._day) {

            //this.arr_Adx[point] = Number(dx * K); // dx n일 지수이동평균 (전일값 = 0)

            this.arr_Adx[point] = dx;

          } else {

            //this.arr_Adx[point] = Number(dx * K + this.arr_Adx[point - 1] * (1 - K)); // dx n일  지수이동평균

            this.arr_Adx[point] = nexChartUtils.calcSma(this.arr_dx,0,point,this._day); // 단순이평

          }

          var valAdx = this.arr_Adx[point];

          this._data3[exceptFlag ? (this._exceptIdx[2] - 1) : point] = [Number(date_utc_time), Number(valAdx.toFixed(2))];

        }

      }

    },

    /**

     * desc : 전체 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @return {Array}

     */

    getData: function(dataNum) {

      var data = [];

      if (dataNum == 1) {

        data = this._data1;

      } else if (dataNum == 2) {

        data = this._data2;

      } else if (dataNum == 3) {

        data = this._data3;

      }

      return data;

    },

    /**

     * desc : index 위치의 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param index : 위치

     * @return {Number}

     */

    getIndexData: function(dataNum, index) {

      var data = [];

      if (dataNum == 1) {

        data = this._data1[index];

      } else if (dataNum == 2) {

        data = this._data2[index];

      } else if (dataNum == 3) {

        data = this._data3[index];

      }

      return data;

    },

    /**

     * desc : 마지막 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param exceptflag : 빈데이터 제외 flag(true: 제외, false: 포함, default: true)

     * @return

     */

    getLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }

      var data = this.getData(dataNum);

      var last_len = data.length - 1;

      // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

      if (exceptFlag && this._exceptIdx[dataNum - 1] != 0) {

        last_len = this._exceptIdx[dataNum - 1] - 1;

      }

      return data[last_len];

    },

    getExceptIdx: function(dataNum) {

        return this._exceptIdx[dataNum - 1];

    }

 };

  



  /**

   * desc : obv 데이터 객체(obv)

   * date : 2015.07.22

   * 

   */

  var obvData = function(chart, seqId, chartData, day) {

	this._chart = chart;

	this._type = 'obv';

    this._id = seqId;

    this._data1 = []; // obv 평균가격

    this._data2 = []; // obv 시그널선

    this._day = day; // 기간(시그널선)



    this._exceptIdx = [];



    this.arr_preobv = [];

    this.arr_signal = [];



    this.init();

    this.setData(chartData);

  }

  obvData.prototype = {

    init: function() {

      this._exceptIdx[0] = 0;

      this._exceptIdx[1] = 0;



      this.arr_preobv = [];

      this.arr_signal = [];

    },

    /**

     * desc : 타입 리턴

     * date : 2015.07.22

     * 

     * @return {String}

     */

    getType: function() {

      return this._type;

    },

    /**

     * desc: id 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getId: function() {

      return this._id;

    },

    /**

     * desc: 기간 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getDay: function() {

      return this._day;

    },

    /**

     * desc : 초기 전체 데이터 가공

     * date : 2015.07.22

     * 

     *

     * OBV (On Ballance Volume) 계산식

     * 당일 종가 > 전일 종가 이면 OBV = 전일 OBV + 당일 거래량

     * 당일 종가 < 전일 종가 이면 OBV = 전일 OBV - 당일 거래량

     * 당일 종가 = 전일 종가 이면 OBV = 전일 OBV

     * @param chartData : 차트 데이터

     */

    setData: function(chartData) {

      if (chartData != null && chartData.length > 0) {

        this.arr_preobv[0] = 0;

        for (var i = 0, len = chartData.length; i < len; i++) {

          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

            // obv 구하기

            var obvVal = 0;

            if (i == 0) {

                obvVal = chartData[i][5];

                this.arr_preobv[i] = obvVal;

            } else {

            	this.arr_preobv[i] = this.arr_preobv[i - 1];



                if (Number(chartData[i][4]) > Number(chartData[i - 1][4])) {

                    obvVal = this.arr_preobv[i - 1] + chartData[i][5];

                    this.arr_preobv[i] = obvVal;

                } else if (Number(chartData[i][4]) < Number(chartData[i - 1][4])) {

                    obvVal = this.arr_preobv[i - 1] - chartData[i][5];

                    this.arr_preobv[i] = obvVal;

                } else if (chartData[i][4] == chartData[i - 1][4]) {

                	obvVal = this.arr_preobv[i - 1];

                }

            } 

            

            this._data1.push([Number(chartData[i][0]), obvVal]);

            this._exceptIdx[0]++;



            //시그널선 구하기 (시그널 기간설정값 this._day)

            if (i == 0) { // i가 0 일때, 초기값은 obvVal 값을 그대로 사용

              this.arr_signal[i] = obvVal;

            } else { // i가 1 보다 클때

              //this.arr_signal[i] = (obvVal * (2 / (this._day + 1))) + this.arr_signal[i - 1] * (1 - (2 / (this._day + 1)));

              this.arr_signal[i] = nexChartUtils.calcSma(this.arr_preobv,0,i,this._day);

            }



            if (i >= this._day) { // i가 9 또는 9 보다 클때

              var signal_val = this.arr_signal[i];

              this._data2.push([Number(chartData[i][0]), Number(signal_val.toFixed(2))]);

              this._exceptIdx[1]++;

            }

          } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

            this._data1.push([Number(chartData[i][0]), null]);

            this._data2.push([Number(chartData[i][0]), null]);



            this.arr_preobv[i] = 0;

            this.arr_signal[i] = 0;

          }

        }

      }

    },

    /**

     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2015.07.22

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      var data_arr = [this._data1, this._data2];

      for (var i = 0; i < 2; i++) {

        var data = data_arr[i];

        data[this._exceptIdx[i]][0] = nexUtils.date2Utc(datePoint);



        for (var j = this._exceptIdx[i] + 1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {

          if (interval == 'MINUTE' || interval == 'HOURS') {

            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

          } else {

            data[j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

          }

        }

      }

    },

    /**

     * desc : 한건의 데이터 추가

     * date : 2015.07.22

     * 

     * @param pointData : 한건의 데이터

     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) { // 빈데이터 추가

        this._data1.push([Number(pointData[0]), null]);

        this._exceptIdx[0]++;

        this._data2.push([Number(pointData[0]), null]);

        this._exceptIdx[1]++;

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2015.07.22

     * 

     * @param point : 업데이트될 위치(index)

     * @param pointData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     */

    updatePointData: function(point, chartData, exceptFlag) {

      if (chartData != null && chartData.length > 0) {

        if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

          exceptFlag = false;

        }

        var date_utc_time = chartData[point][0];

        

        // obv 구하기

        var obvVal = 0;

        if (point == 0) {

        	obvVal = chartData[point][5];

            this.arr_preobv[point] = obvVal;

        } else {

        	 if (chartData[point][4] > chartData[point - 1][4]) {

                 obvVal = this.arr_preobv[point - 1] + chartData[point][5];

                 this.arr_preobv[point] = obvVal;

             } else if (chartData[point][4] < chartData[point - 1][4]) {

                 obvVal = this.arr_preobv[point - 1] - chartData[point][5];

                 this.arr_preobv[point] = obvVal;

             } else if (chartData[point][4] == chartData[point - 1][4]) {

             	obvVal = this.arr_preobv[point - 1];

             } 

        }



        this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), obvVal];



        //시그널선 구하기

        if (point == 0) { // i가 1 일때, 초기값은 obvVal 값을 그대로 사용

          this.arr_signal[point] = obvVal;

        } else { // i가 1 보다 클때

          //this.arr_signal[point] = (obvVal * (2 / (this._day + 1))) + this.arr_signal[point - 1] * (1 - (2 / (this._day + 1)));

          this.arr_signal[point] = nexChartUtils.calcSma(this.arr_preobv,0,point,this._day);

        }



        if (point >= this._day) { // i가 9 또는 9 보다 클때

          var signal_val = this.arr_signal[point];

          this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point] = [Number(date_utc_time), Number(signal_val.toFixed(2))];

        }

      }

    },

    /**

     * desc : 전체 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @return {Array}

     */

    getData: function(dataNum) {

      var data = [];

      if (dataNum == 1) {

        data = this._data1;

      } else if (dataNum == 2) {

        data = this._data2;

      }

      return data;

    },

    /**

     * desc : index 위치의 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param index : 위치

     * @return {Number}

     */

    getIndexData: function(dataNum, index) {

      var index_data = {};

      if (dataNum == 1) {

        index_data = this._data1[index];

      } else if (dataNum == 2) {

        index_data = this._data2[index];

      }

      return index_data;

    },

    /**

     * desc : 마지막 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param exceptflag : 빈데이터 제외 flag(true: 제외, false: 포함, default: true)

     * @return

     */

    getLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }

      var data = this.getData(dataNum),

        last_len = data.length - 1;

      // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

      if (exceptFlag && this._exceptIdx[dataNum - 1] != 0) {

        last_len = this._exceptIdx[dataNum - 1] - 1;

      }

      return data[last_len];

    },

    /**

     * desc : 빈데이터 시작 IDX 반환

     * date : 2015.07.22

     * 

     * @param : 가져올 데이터의 index

     * @return {Number}

     */

    getExceptIdx: function(dataNum) {

      return this._exceptIdx[dataNum - 1];

    }

  };



  /**

   * desc : sonar 데이터 객체(sonar)

   * date : 2015.07.22

   * 

   */

  var sonarData = function(chart, seqId, chartData, emaNum1, day, signal) {

	 this._chart = chart;

	 this._type = 'sonar';

    this._id = seqId;

    this._data1 = []; // sonar

    this._data2 = []; // signal

    this._emaNum1 = emaNum1; // 지수 이평선1

    this._day = day; // 기간

    this._signal = signal; // signal



    this._exceptIdx = [];



    this.arr_sonar = [];

    this.arr_ema = [];

    this.arr_signal = [];



    this.init();

    this.setData(chartData);

  }

  sonarData.prototype = {

    init: function() {

      this._exceptIdx[0] = 0;

      this._exceptIdx[1] = 0;



      this.arr_sonar = [];

      this.arr_ema = [];

      this.arr_signal = [];

    },

    /**

     * desc : 타입 리턴

     * date : 2015.07.22

     * 

     * @return {String}

     */

    getType: function() {

      return this._type;

    },

    /**

     * desc: id 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getId: function() {

      return this._id;

    },

    /**

     * desc: 지수이평선1값 반환

     * date : 2015.07.22

     * 

     * @return

     */

    getEmaNum1: function() {

      return this._emaNum1;

    },

    /**

     * desc: 기간 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getDay: function() {

      return this._day;

    },

    /**

     * desc: 시그널값 반환

     * date : 2015.07.22

     * 

     * @return

     */

    getSignal: function() {

      return this._signal;

    },

    /**

     * desc : 초기 전체 데이터 가공

     * date : 2015.07.22

     * 

     *

     * SONAR 계산식

     * SONAR = 100 * 당일지수이동평균 - n일전 지수이동평균 / n일전 지수이동평균

     * 시그널선 = SONAR의 n일 지수이동평균

     * 기본이평기간 20, 기본비교기간 9, 기본Signal기간 9

     *

     * @param chartData : 차트 데이터

     */

    setData: function(chartData) {

      if (chartData != null && chartData.length > 0) {

        for (var i = 0, len = chartData.length; i < len; i++) {

          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

            if (i >= (this._emaNum1 + this._day - 1)) { // i가 28 또는 28 보다 클때

              // SONAR 계산

              //this.arr_ema[i] = (chartData[i][4] * (2 / (this._emaNum1 + 1))) + this.arr_ema[i - 1] * (1 - (2 / (this._emaNum1 + 1)));

              this.arr_ema[i] = nexChartUtils.calcSma(chartData,4,i,this._emaNum1);



              var sonarVal = 100 * (this.arr_ema[i] - this.arr_ema[i - this._day]) / this.arr_ema[i - this._day];

              

              this.arr_sonar[i] = sonarVal;

              this._data1.push([Number(chartData[i][0]), Number(sonarVal.toFixed(2))]);

              this._exceptIdx[0]++;



              // 시그널선 계산

              if (i == this._emaNum1 + this._day - 1) { // i가 28일때, 초기값은 sonar 값을 그대로 사용

                this.arr_signal[i] = sonarVal;

              } else { // i가 28보다 클때

                //this.arr_signal[i] = (sonarVal * (2 / (this._signal + 1))) + this.arr_signal[i - 1] * (1 - (2 / (this._signal + 1)));

                this.arr_signal[i] = nexChartUtils.calcSma(this.arr_sonar,0,i,this._signal);

              }

              if (i >= this._emaNum1 + this._day + this._signal - 2) { // i가 36 또는 36 보다 클때

                var signal_val = this.arr_signal[i];



                this._data2.push([Number(chartData[i][0]), Number(signal_val.toFixed(2))]);

                this._exceptIdx[1]++;

              }

            } else {

              if (i == 0) {

                this.arr_ema[i] = chartData[i][4];

              } else {

                //this.arr_ema[i] = (chartData[i][4] * (2 / (this._emaNum1 + 1))) + this.arr_ema[i - 1] * (1 - (2 / (this._emaNum1 + 1)));

                this.arr_ema[i] = nexChartUtils.calcSma(chartData,4,i,this._emaNum1);

              }

            }

          } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

            this._data1.push([Number(chartData[i][0]), null]);

            this._data2.push([Number(chartData[i][0]), null]);



            this.arr_signal[i] = 0;

            this.arr_ema[i] = 0;

          }

        }

      }

    },

    /**

     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2015.07.22

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      var data_arr = [this._data1, this._data2];

      for (var i = 0; i < 2; i++) {

        var data = data_arr[i];

        data[this._exceptIdx[i]][0] = nexUtils.date2Utc(datePoint);



        for (var j = this._exceptIdx[i] + 1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {

          if (interval == 'MINUTE' || interval == 'HOURS') {

            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

          } else {

            data[j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

          }

        }

      }

    },

    /**

     * desc : 한건의 데이터 추가

     * date : 2015.07.22

     * 

     * @param pointData : 한건의 데이터

     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) { // 빈데이터 추가

        this._data1.push([Number(pointData[0]), null]);

        this._exceptIdx[0]++;

        this._data2.push([Number(pointData[0]), null]);

        this._exceptIdx[1]++;

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2015.07.22

     * 

     * @param point : 업데이트될 위치(index)

     * @param pointData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     */

    updatePointData: function(point, chartData, exceptFlag) {

      if (chartData != null && chartData.length > 0) {

        if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

          exceptFlag = false;

        }

        var date_utc_time = chartData[point][0];

        if (point >= (this._emaNum1 + this._day - 1)) { // i가 28 또는 28 보다 클때

          // SONAR 계산

          //this.arr_ema[point] = (chartData[point][4] * (2 / (this._emaNum1 + 1))) + this.arr_ema[point - 1] * (1 - (2 / (this._emaNum1 + 1)));

          this.arr_ema[point] = nexChartUtils.calcSma(chartData,4,point,this._emaNum1);



          var sonarVal = 100 * (this.arr_ema[point] - this.arr_ema[point - this._day]) / this.arr_ema[point - this._day];

          this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), Number(sonarVal.toFixed(2))];



          // 시그널선 계산

          if (point == this._emaNum1 + this._day - 1) { // i가 28일때, 초기값은 sonar 값을 그대로 사용

            this.arr_signal[point] = sonarVal;

          } else { // i가 28보다 클때

            //this.arr_signal[point] = (sonarVal * (2 / (this._signal + 1))) + this.arr_signal[point - 1] * (1 - (2 / (this._signal + 1)));

            this.arr_signal[point] = nexChartUtils.calcSma(this.arr_sonar,0,point,this._signal);



          }



          if (point >= this._emaNum1 + this._day + this._signal - 2) { // i가 36 또는 36 보다 클때

            var signal_val = this.arr_signal[point];

            this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point] = [Number(date_utc_time), Number(signal_val.toFixed(2))];

          }

        } else {

          if (point == 0) {

            this.arr_ema[point] = chartData[point][4];

          } else {

            //this.arr_ema[point] = (chartData[point][4] * (2 / (this._emaNum1 + 1))) + this.arr_ema[point - 1] * (1 - (2 / (this._emaNum1 + 1)));

        	  this.arr_ema[point] = nexChartUtils.calcSma(chartData,4,point,this._emaNum1);

          }

        }

      }

    },

    /**

     * desc : 전체 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @return {Array}

     */

    getData: function(dataNum) {

      var data = [];

      if (dataNum == 1) {

        data = this._data1;

      } else if (dataNum == 2) {

        data = this._data2;

      }

      return data;

    },

    /**

     * desc : index 위치의 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param index : 위치

     * @return {Number}

     */

    getIndexData: function(dataNum, index) {

      var index_data = {};

      if (dataNum == 1) {

        index_data = this._data1[index];

      } else if (dataNum == 2) {

        index_data = this._data2[index];

      }

      return index_data;

    },

    /**

     * 차트별 index 위치의 데이터 복사하여 리턴.

     * @param dataNum

     * @param index

     * @return

     */

    getCloneIndexData: function(dataNum, index) {

      if (dataNum == 1) {

        return {

          x: this._data1[index].x,

          y: this._data1[index].y,

          ema1: this._data1[index].ema1,

          ema2: this._data1[index].ema2

        };

      } else if (dataNum == 2) {

        return {

          x: this._data2[index].x,

          y: this._data2[index].y,

          macd: this._data2[index].macd

        };

      }

    },

    /**

     * desc : 마지막 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param exceptflag : 빈데이터 제외 flag(true: 제외, false: 포함, default: true)

     * @return

     */

    getLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

	    exceptFlag = true;

	  }

	  var data = this.getData(dataNum),

	    last_len = data.length - 1;

	  // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

	  if (exceptFlag && this._exceptIdx[dataNum - 1] != 0) {

	    last_len = this._exceptIdx[dataNum - 1] - 1;

	  }

	  return data[last_len];

    },

    /**

     * 차트별 마지막 데이터 복사하여 리턴.

     * @param dataNum

     * @param exceptFlag: 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     * @return {}

     */

    getCloneLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }



      var last_data = {},

        last_len = 0;



      if (dataNum == 1) {

        last_len = this._data1.length;



        // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

        if (exceptFlag && this._exceptIdx[0] != 0) {

          last_len = this._exceptIdx[0] - 1;

        }



        last_data = {

          x: this._data1[last_len].x,

          y: this._data1[last_len].y,

          ema1: this._data1[last_len].ema1,

          ema2: this._data1[last_len].ema2

        };

      } else if (dataNum == 2) {

        last_len = this._data2.length;



        // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

        if (exceptFlag && this._exceptIdx[1] != 0) {

          last_len = this._exceptIdx[1] - 1;

        }



        last_data = {

          x: this._data2[last_len].x,

          y: this._data2[last_len].y,

          macd: this._data2[last_len].macd

        };

      }



      return last_data;

    },



    /**

     * desc : 빈데이터 시작 IDX 반환

     * date : 2015.07.22

     * 

     * @param : 가져올 데이터의 index

     * @return {Number}

     */

    getExceptIdx: function(dataNum) {

      return this._exceptIdx[dataNum - 1];

    }

  };



  /**

   * desc : vr 데이터 객체(vr)

   * date : 2015.07.22

   * 

   */

  var vrData = function(chart, seqId, chartData, day) {

	 this._chart = chart;

	 this._type = 'vr';

    this._id = seqId;

    this._data = []; //vr 평균가격

    this._day = day; //기간



    this._exceptIdx = 0;



    this.arr_Up = [];

    this.arr_Dn = [];

    this.arr_Eq = [];



    this.arr_UpSum = [];

    this.arr_DnSum = [];

    this.arr_EqSum = [];



    this.init();

    this.setData(chartData);

  }

  vrData.prototype = {

    init: function() {

      this._exceptIdx = 0;



      this.arr_Up = [];

      this.arr_Dn = [];

      this.arr_Eq = [];



      this.arr_UpSum = [];

      this.arr_DnSum = [];

      this.arr_EqSum = [];

    },

    /**

     * desc : 타입 리턴

     * date : 2015.07.22

     * 

     * @return {String}

     */

    getType: function() {

      return this._type;

    },

    /**

     * desc: id 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getId: function() {

      return this._id;

    },

    /**

     * desc: 기간 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getDay: function() {

      return this._day;

    },

    /**

     * desc : 초기 전체 데이터 가공

     * date : 2015.07.22

     * 

     *

     * VR (Volume Ratio) 계산식

     * VR = {(주가상승일 거래량 합계+주가보합일 거래량 합계*0.5)/(주가하락일 거래량 합계+주가보합일 거래량 합계*0.5)} * 100

     * 기본 적용기간: 20일

     * @param chartData : 차트 데이터

     */

    setData: function(chartData) {

      if (chartData != null && chartData.length > 0) {

        this.arr_UpSum[0] = 0;

        this.arr_EqSum[0] = 0;

        this.arr_DnSum[0] = 0;



        // for문 1 부터 시작임 !!!

        for (var i = 1, len = chartData.length; i < len; i++) {

          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

            this.arr_Up[i] = 0; // 주가상승일 거래량

            this.arr_Dn[i] = 0; // 주가하락일 거래량

            this.arr_Eq[i] = 0; // 주가보합일 거래량



            if (Number(chartData[i][4]) > Number(chartData[i - 1][4])) {

              this.arr_Up[i] = Number(chartData[i][5]);

            }



            if (Number(chartData[i][4]) == Number(chartData[i - 1][4])) {

              this.arr_Eq[i] = Number(chartData[i][5]);

            }



            if (Number(chartData[i][4]) < Number(chartData[i - 1][4])) {

              this.arr_Dn[i] = Number(chartData[i][5]);

            }



            if (i >= this._day) {

              this.arr_UpSum[i] = this.arr_UpSum[i - 1] + this.arr_Up[i];

              this.arr_EqSum[i] = this.arr_EqSum[i - 1] + this.arr_Eq[i];

              this.arr_DnSum[i] = this.arr_DnSum[i - 1] + this.arr_Dn[i];



              if (i - (this._day) > 0) {

                this.arr_UpSum[i] -= this.arr_Up[i - this._day];

                this.arr_EqSum[i] -= this.arr_Eq[i - this._day];

                this.arr_DnSum[i] -= this.arr_Dn[i - this._day];

              }



              var Value1 = this.arr_UpSum[i] + this.arr_EqSum[i] * 0.5,

                Value2 = this.arr_DnSum[i] + this.arr_EqSum[i] * 0.5,

                vrVal = 0;

              if (Value2 != 0) {

                vrVal = Number((Value1 / Value2) * 100).toFixed(2);

              }



              this._data.push([Number(chartData[i][0]), Number(vrVal)]);

            } else {

              this.arr_UpSum[i] = this.arr_UpSum[i - 1] + this.arr_Up[i];

              this.arr_EqSum[i] = this.arr_EqSum[i - 1] + this.arr_Eq[i];

              this.arr_DnSum[i] = this.arr_DnSum[i - 1] + this.arr_Dn[i];



              this._data.push([Number(chartData[i][0]), null]);

            }

            this._exceptIdx++;

          } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

            this._data.push([Number(chartData[i][0]), null]);



            this.arr_Up[i] = 0;

            this.arr_Eq[i] = 0;

            this.arr_Dn[i] = 0;



            this.arr_UpSum[i] = 0;

            this.arr_EqSum[i] = 0;

            this.arr_DnSum[i] = 0;

          }

        }

      }

    },

    /**

     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2015.07.22

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      this._data[this._exceptIdx][0] = nexUtils.date2Utc(datePoint);

      for (var i = this._exceptIdx + 1, len = this._data.length, up_cnt = 1; i < len; i++, up_cnt++) {

        if (interval == 'MINUTE' || interval == 'HOURS') {

          this._data[i][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

        } else {

          this._data[i][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

        }

      }

    },

    /**

     * desc : 한건의 데이터 추가

     * date : 2015.07.22

     * 

     * @param pointData : 한건의 데이터

     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) { // 빈데이터 추가

        this._data.push([Number(pointData[0]), null]);

        this._exceptIdx++;

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2015.07.22

     * 

     * @param point : 업데이트될 위치(index)

     * @param pointData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     */

    updatePointData: function(point, chartData, exceptFlag) {

      if (chartData != null && chartData.length > 0) {

        this.arr_Up[point] = 0; // 주가상승일 거래량

        this.arr_Dn[point] = 0; // 주가하락일 거래량

        this.arr_Eq[point] = 0; // 주가보합일 거래량



        var date_utc_time = chartData[point][0];



        if (Number(chartData[point][4]) > Number(chartData[point - 1][4])) {

          this.arr_Up[point] = Number(chartData[point][5]);

        }



        if (Number(chartData[point][4]) == Number(chartData[point - 1][4])) {

          this.arr_Eq[point] = Number(chartData[point][5]);

        }



        if (Number(chartData[point][4]) < Number(chartData[point - 1][4])) {

          this.arr_Dn[point] = Number(chartData[point][5]);

        }



        if (point >= this._day) {

          this.arr_UpSum[point] = this.arr_UpSum[point - 1] + this.arr_Up[point];

          this.arr_EqSum[point] = this.arr_EqSum[point - 1] + this.arr_Eq[point];

          this.arr_DnSum[point] = this.arr_DnSum[point - 1] + this.arr_Dn[point];



          if (point - (this._day) > 0) {

            this.arr_UpSum[point] -= this.arr_Up[point - this._day];

            this.arr_EqSum[point] -= this.arr_Eq[point - this._day];

            this.arr_DnSum[point] -= this.arr_Dn[point - this._day];

          }



          var Value1 = this.arr_UpSum[point] + this.arr_EqSum[point] * 0.5,

            Value2 = this.arr_DnSum[point] + this.arr_EqSum[point] * 0.5,

            vrVal = 0;

          if (Value2 != 0) {

            vrVal = Number((Value1 / Value2) * 100).toFixed(2);

          }



          this._data[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), Number(vrVal)];

        } else {

          this.arr_UpSum[point] = this.arr_UpSum[point - 1] + this.arr_Up[point];

          this.arr_EqSum[point] = this.arr_EqSum[point - 1] + this.arr_Eq[point];

          this.arr_DnSum[point] = this.arr_DnSum[point - 1] + this.arr_Dn[point];



          this._data[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), null];

        }

      }

    },

    /**

     * desc : 전체 데이터 반환

     * date : 2015.07.22

     * 

     * @return {Array}

     */

    getData: function() {

      return this._data;

    },

    /**

     * desc : index 위치의 데이터 반환

     * date : 2015.07.22

     * 

     * @param index : 위치

     * @return {Number}

     */

    getIndexData: function(index) {

      var data = [];

      data = this._data[index];

      return data;

    },

    /**

     * desc : 마지막 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param exceptflag : 빈데이터 제외 flag(true: 제외, false: 포함, default: true)

     * @return

     */

    getLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }

      var last_len = this._data.length - 1;

      // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

      if (exceptFlag && this._exceptIdx != 0) {

        last_len = this._exceptIdx - 1;

      }

      return this._data[last_len];

    },

    /**

     * desc : 빈데이터 시작 IDX 반환

     * date : 2015.07.22

     * 

     * @return {Number}

     */

    getExceptIdx: function() {

      return this._exceptIdx;

    }

  };



  /**

   * desc : trix 데이터 객체(trix)

   * date : 2015.07.22

   * 

   */

  var trixData = function(chart, seqId, chartData, day, signal) {

	this._chart = chart;

	this._type = 'trix';

    this._id = seqId;

    this._data1 = []; //Trix

    this._data2 = []; //signal

    this._day = day; //기간

    this._signal = signal; //signal



    this._exceptIdx = [];



    this.arr_ema1 = [];

    this.arr_ema2 = [];

    this.arr_ema3 = [];

    

    this.arr_ema1_1 = [];

    this.arr_ema2_1 = [];

    this.arr_ema3_1 = [];

    

    this.arr_trix = [];

    this.arr_signal = [];



    this.init();

    this.setData(chartData);

  }

  trixData.prototype = {

    init: function() {

      this._exceptIdx[0] = 0;

      this._exceptIdx[1] = 0;



      this.arr_ema1 = [];

      this.arr_ema2 = [];

      this.arr_ema3 = [];

      

      this.arr_ema1_1 = [];

      this.arr_ema2_1 = [];

      this.arr_ema3_1 = [];



      this.arr_trix = [];

      this.arr_signal = [];

    },

    /**

     * desc : 타입 리턴

     * date : 2015.07.22

     * 

     * @return {String}

     */

    getType: function() {

      return this._type;

    },

    /**

     * desc: id 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getId: function() {

      return this._id;

    },

    /**

     * desc: 기간 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getDay: function() {

      return this._day;

    },

    /**

     * desc: 시그널값 반환

     * date : 2015.07.22

     * 

     * @return

     */

    getSignal: function() {

      return this._signal;

    },

    /**

     * desc : 초기 전체 데이터 가공

     * date : 2015.07.22

     * 

     *

     * EMA1 : 종가의 해당기간 (n) 지수이동평균값

     * EMA2 : EMA1 (n) 지수이동평균

     * EMA3 : EMA2 (n) 지수이동평균

     * TRIX : EMA3의 당일 변동분 = [(당일 EMA3 - 전일 EMA3) / 전일 EMA3] * 100

     * 시그널선 = TRIX의 n일 지수이동평균

     * EMA (지수이동평균) = C * K + Xp (1-K) (C : 당일치, Xp : 전일이동평균, K(exponential percentage)=2/(n+1))

     * 기본설정값: 12일, 시그널선: 9일

     *

     * @param chartData : 차트 데이터

     */

    setData: function(chartData) {

      if (chartData != null && chartData.length > 0) {

        for (var i = 0, len = chartData.length; i < len; i++) {

          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {



            var trixVal = null;



            //EMA1, EMA2, EMA3 구하기

            if (i < this._day - 1) { // i가 11보다 작을때

              this.arr_ema1[i] = 0;

              this.arr_ema2[i] = 0;

            } else {

              //this.arr_ema1[i] = (chartData[i][4] * (2 / (this._day + 1))) + this.arr_ema1[i - 1] * (1 - (2 / (this._day + 1)));

            	this.arr_ema1[i] = nexChartUtils.calcSma(chartData,4,i,this._day);

              //this.arr_ema2[i] = (this.arr_ema1[i] * (2 / (this._day + 1))) + this.arr_ema2[i - 1] * (1 - (2 / (this._day + 1)));

            	this.arr_ema2[i] = nexChartUtils.calcSma(this.arr_ema1,0,i,this._day);

            }



            if (i < this._day * 2 - 2) { // i가 22보다 작을때

              this.arr_ema3[i] = 0;

            } else {

              //this.arr_ema3[i] = (this.arr_ema2[i] * (2 / (this._day + 1))) + this.arr_ema3[i - 1] * (1 - (2 / (this._day + 1)));

                this.arr_ema3[i] = nexChartUtils.calcSma(this.arr_ema2,0,i,this._day);

            }



            if (i >= this._day * 3 - 2) { // i가 34보다 작을때

              trixVal = ((this.arr_ema3[i] - this.arr_ema3[i - 1]) / this.arr_ema3[i - 1]) * 100;

              

              this.arr_trix[i] = trixVal;

              this._data1.push([Number(chartData[i][0]), Number(trixVal.toFixed(2))]);

              this._exceptIdx[0]++;

            }



            //시그널선 계산하기

            if (i == this._day * 3 - 2) { // i가 34일때 초기값은 trix 값을 그대로 사용

              this.arr_signal[i] = trixVal;

            } else { // i가 34보다 클때

              //this.arr_signal[i] = (trixVal * (2 / (this._signal + 1))) + this.arr_signal[i - 1] * (1 - (2 / (this._signal + 1)));

            	this.arr_signal[i] = nexChartUtils.calcSma(this.arr_trix,0,i,this._signal);

            }



            if (i >= this._day * 3 - 2 + this._signal - 1) { // i가 42와 같거나 클때

              var signal_val = this.arr_signal[i];



              this._data2.push([Number(chartData[i][0]), Number(signal_val.toFixed(2))]);

              this._exceptIdx[1]++;

            }

          } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

            this._data1.push([Number(chartData[i][0]), null]);

            this._data2.push([Number(chartData[i][0]), null]);



            this.arr_ema1[i] = 0;

            this.arr_ema2[i] = 0;

            this.arr_ema3[i] = 0;



            this.arr_signal[i] = 0;

          }

          /* console.log(

                + i + "//" + chartData[i][6] + "//"

                //+ chartData[i][1] + "//" + chartData[i][2] + "//" + chartData[i][3] + "//" + chartData[i][4] + "//"

                + temp_ema1[i] + "//" + temp_ema2[i] + "//" + temp_ema2[i] + "//" + trixVal + "//" + signal_val

                ); */

        }

      }

    },

    /**

     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2015.07.22

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      var data_arr = [this._data1, this._data2];

      for (var i = 0; i < 2; i++) {

        var data = data_arr[i];

        data[this._exceptIdx[i]][0] = nexUtils.date2Utc(datePoint);



        for (var j = this._exceptIdx[i] + 1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {

          if (interval == 'MINUTE' || interval == 'HOURS') {

            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

          } else {

            data[j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

          }

        }

      }

    },

    /**

     * desc : 한건의 데이터 추가

     * date : 2015.07.22

     * 

     * @param pointData : 한건의 데이터

     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) { // 빈데이터 추가

        this._data1.push([Number(pointData[0]), null]);

        this._exceptIdx[0]++;

        this._data2.push([Number(pointData[0]), null]);

        this._exceptIdx[1]++;

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2015.07.22

     * 

     * @param point : 업데이트될 위치(index)

     * @param pointData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     */

    updatePointData: function(point, chartData, exceptFlag) {

      if (chartData != null && chartData.length > 0) {

        if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

          exceptFlag = false;

        }



        var trixVal = null,

          date_utc_time = chartData[point][0];



        //EMA1, EMA2, EMA3 구하기

        if (point < this._day - 1) { // i가 11보다 작을때

          this.arr_ema1[point] = 0;

          this.arr_ema2[point] = 0;

        } else {

          //this.arr_ema1[point] = (chartData[point][4] * (2 / (this._day + 1))) + this.arr_ema1[point - 1] * (1 - (2 / (this._day + 1)));

        	this.arr_ema1[point] = nexChartUtils.calcSma(chartData,4,point,this._day);

          //this.arr_ema2[point] = (this.arr_ema1[point] * (2 / (this._day + 1))) + this.arr_ema2[point - 1] * (1 - (2 / (this._day + 1)));

        	this.arr_ema2[point] = nexChartUtils.calcSma(this.arr_ema1,0,point,this._day);

        }



        if (point < this._day * 2 - 2) { // i가 22보다 작을때

          this.arr_ema3[point] = 0;

        } else {

          //this.arr_ema3[point] = (this.arr_ema2[point] * (2 / (this._day + 1))) + this.arr_ema3[point - 1] * (1 - (2 / (this._day + 1)));

        	this.arr_ema3[point] = nexChartUtils.calcSma(this.arr_ema2,0,point,this._day);

        }



        if (point >= this._day * 3 - 2) { // i가 34보다 작을때

          trixVal = ((this.arr_ema3[point] - this.arr_ema3[point - 1]) / this.arr_ema3[point - 1]) * 100;

          this.arr_trix[point] = trixVal;

          this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), Number(trixVal.toFixed(2))];

        }



        //시그널선 계산하기

        if (point == this._day * 3 - 2) { // i가 34일때 초기값은 trix 값을 그대로 사용

          this.arr_signal[point] = trixVal;

        } else { // i가 34보다 클때

          //this.arr_signal[point] = (trixVal * (2 / (this._signal + 1))) + this.arr_signal[point - 1] * (1 - (2 / (this._signal + 1)));

          this.arr_signal[point] = nexChartUtils.calcSma(this.arr_trix,0,point,this._signal);

        }



        if (point >= this._day * 3 - 2 + this._signal - 1) { // i가 42와 같거나 클때

          var signal_val = this.arr_signal[point];

          this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point] = [Number(date_utc_time), Number(signal_val.toFixed(2))];

        }

      }

    },

    /**

     * desc : 전체 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @return {Array}

     */

    getData: function(dataNum) {

      var data = [];

      if (dataNum == 1) {

        data = this._data1;

      } else if (dataNum == 2) {

        data = this._data2;

      }

      return data;

    },

    /**

     * desc : index 위치의 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param index : 위치

     * @return {Number}

     */

    getIndexData: function(dataNum, index) {

      var index_data = {};

      if (dataNum == 1) {

        index_data = this._data1[index];

      } else if (dataNum == 2) {

        index_data = this._data2[index];

      }

      return index_data;

    },

    /**

     * 차트별 index 위치의 데이터 복사하여 리턴.

     * @param dataNum

     * @param index

     * @return {}

     */

    getCloneIndexData: function(dataNum, index) {

      var last_data = {};

      if (dataNum == 1) {

        last_data = {

          x: this._data1[index].x,

          y: this._data1[index].y,

          ema1: this._data1[index].ema1,

          ema2: this._data1[index].ema2

        };

      } else if (dataNum == 2) {

        last_data = {

          x: this._data2[index].x,

          y: this._data2[index].y,

          macd: this._data2[index].macd

        };

      }

      return last_data;

    },

    /**

     * desc : 마지막 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param exceptflag : 빈데이터 제외 flag(true: 제외, false: 포함, default: true)

     * @return

     */

    getLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }



      var last_data = {},

        last_len = 0;

      if (dataNum == 1) {

        last_len = this._data1.length - 1;

        // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

        if (exceptFlag && this._exceptIdx[0] != 0) {

          last_len = this._exceptIdx[0] - 1;

        }

        last_data = this._data1[last_len];

      } else if (dataNum == 2) {

        last_len = this._data2.length - 1;

        // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

        if (exceptFlag && this._exceptIdx[1] != 0) {

          last_len = this._exceptIdx[1] - 1;

        }

        last_data = this._data2[last_len];

      }

      return last_data;

    },

    /**

     * 차트별 마지막 데이터 복사하여 리턴.

     * @param dataNum

     * @param exceptFlag: 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     * @return {}

     */

    getCloneLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }



      var last_data = {},

        last_len = 0;

      if (dataNum == 1) {

        last_len = this._data1.length - 1;

        // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

        if (exceptFlag && this._exceptIdx[0] != 0) {

          last_len = this._exceptIdx[0] - 1;

        }

        last_data = {

          x: this._data1[last_len].x,

          y: this._data1[last_len].y,

          ema1: this._data1[last_len].ema1,

          ema2: this._data1[last_len].ema2

        };

      } else if (dataNum == 2) {

        last_len = this._data2.length - 1;

        // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

        if (exceptFlag && this._exceptIdx[1] != 0) {

          last_len = this._exceptIdx[1] - 1;

        }

        last_data = {

          x: this._data2[last_len].x,

          y: this._data2[last_len].y,

          macd: this._data2[last_len].macd

        };

      }

      return last_data;

    },

    /**

     * desc : 빈데이터 시작 IDX 반환

     * date : 2015.07.22

     * 

     * @param : 가져올 데이터의 index

     * @return {Number}

     */

    getExceptIdx: function(dataNum) {

      return this._exceptIdx[dataNum - 1];

    }

  };



  /**

   * desc : williams 데이터 객체(williams)

   * date : 2016.04.25

   * 

   */

  var williamsData = function(chart, seqId, chartData, day, signal) {

	this._chart = chart;

	this._type = 'williams';

    this._id = seqId;

    this._data1 = []; // williams

    this._data2 = []; // signal

    

    this._day = day; // 기간

    this._signal = signal; //Signal



    this.arr_williams = [];

    this.arr_signal = [];

    

    this._exceptIdx = [];



    this.init();

    this.setData(chartData);

  }

  williamsData.prototype = {

    init: function() {

    	this._exceptIdx[0] = 0;

    	this._exceptIdx[1] = 0;

    	

    	this.arr_williams = [];

    	this.arr_signal = [];

    },

    /**

     * desc : 타입 리턴

     * date : 2016.04.25

     * 

     * @return {String}

     */

    getType: function() {

      return this._type;

    },

    /**

     * desc: id 리턴

     * date : 2016.04.25

     * 

     * @return

     */

    getId: function() {

      return this._id;

    },

    /**

     * desc: 기간 리턴

     * date : 2016.04.25

     * 

     * @return

     */

    getDay: function() {

      return this._day;

    },

    /**

     * desc : 초기 전체 데이터 가공

     * date : 2016.04.25

     *

     * williams'%R 

	 * 적용기간 중에 움직인 가격 범위에서 오늘의 시장가격이 상대적으로 어디에 위치하고 있는지를 알려주는 지표로써 Stochastics와 유사한 의미를 가집니다.

     * williams'%R 계산식

     * williams'%R = [당일종가-(최근n일중 최고가)/(최근n일중 최고가-최근n일중 최저가)] * 100

     * 

     * @param chartData : 차트 데이터

     */

    setData: function(chartData) {

      if (chartData != null && chartData.length > 0) {

        // williams 구하기

        for (var i = 0, len = chartData.length; i < len; i++) {

          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

            var williams = 0;

            if (i - this._day >= 0) {

              var toate_close_price = chartData[i][4]; // 당일종가

              var dates_high_price = nexChartUtils.getHighMax(i, this._day, chartData); //최근 n일 최고가

              var dates_Low_price = nexChartUtils.getLowMin(i, this._day, chartData); //최근 n일 최저가



              williams = Number((toate_close_price - dates_high_price) / (dates_high_price - dates_Low_price) * 100);

              this.arr_williams[i] = williams;

              this._data1.push([Number(chartData[i][0]), Number((Math.round(williams * 100)) / 100)]);

              this._exceptIdx[0]++;

            }

            

            // 시그널선 계산

            var signal_day = this._signal;

            if (i == this._day) {

              this.arr_signal[i] = williams;

            } else { // i가 10 보다 클때

              //this.arr_signal[i] = (williams * (2 / (signal_day + 1))) + this.arr_signal[i - 1] * (1 - (2 / (signal_day + 1)));

            	this.arr_signal[i] = nexChartUtils.calcSma(this.arr_williams,0,i,signal_day);

            }



            if (i >= this._day + signal_day - 1) { // i가 20 또는 20 보다 클때

              var signal_val = this.arr_signal[i];

              this._data2.push([Number(chartData[i][0]), Number(signal_val.toFixed(2))]);

              this._exceptIdx[1]++;

            }

            

          } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

              this._data1.push([Number(chartData[i][0]), null]);

              this._data2.push([Number(chartData[i][0]), null]);

              this.arr_signal[i] = 0;

          }

        }

      }

    },

    /**

     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2016.04.25

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      var data_arr = [this._data1, this._data2];

      for (var i = 0; i < 2; i++) {

        var data = data_arr[i];

        data[this._exceptIdx[i]][0] = nexUtils.date2Utc(datePoint);



        for (var j = this._exceptIdx[i] + 1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {

          if (interval == 'MINUTE' || interval == 'HOURS') {

            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

          } else {

            data[j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

          }

        }

      }

    },

    /**

     * desc : 한건의 데이터 추가

     * date : 2016.04.25

     * 

     * @param pointData : 한건의 데이터

     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) { // 빈데이터 추가

        this._data1.push([Number(pointData[0]), null]);

        this._exceptIdx[0]++;

        this._data2.push([Number(pointData[0]), null]);

        this._exceptIdx[1]++;

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2016.04.25

     * 

     * @param point : 업데이트될 위치(index)

     * @param pointData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     */

    updatePointData: function(point, chartData, exceptFlag) {

      if (chartData != null && chartData.length > 0) {

        var date_utc_time = chartData[point][0],

          williams = 0;



        if (point - this._day >= 0) {

          var toate_close_price = chartData[point][4],

            dates_high_price = nexChartUtils.getHighMax(point, this._day, chartData),

            dates_Low_price = nexChartUtils.getLowMin(point, this._day, chartData);



          williams = Number((toate_close_price - dates_high_price) / (dates_high_price - dates_Low_price) * 100);

          this.arr_williams[point] = williams;

          this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), Number((Math.round(williams * 100)) / 100)];

        }

        

        // 시그널선 계산

        var signal_day = this._signal;

        if (point == this._day) { // i가 12 일때, 초기값은 williams 값을 그대로 사용

          this.arr_signal[point] = williams;

        } else { // i가 10 보다 클때

          //this.arr_signal[point] = (williams * (2 / (signal_day + 1))) + this.arr_signal[point - 1] * (1 - (2 / (signal_day + 1)));

            this.arr_signal[point] = nexChartUtils.calcSma(this.arr_williams,0,point,signal_day);

        }



        if (point >= this._day + signal_day - 1) { // i가 20 또는 20 보다 클때

          var signal_val = this.arr_signal[point];

          this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point] = [Number(date_utc_time), Number(signal_val.toFixed(2))];

        }

      }

    },

    /**

     * desc : 전체 데이터 반환

     * date : 2016.04.25

     * 

     * @param dataNum : 가져올 데이터의 index

     * @return {Array}

     */

    getData: function(dataNum) {

      var data = [];

      if (dataNum == 1) {

        data = this._data1;

      } else if (dataNum == 2) {

        data = this._data2;

      }

      return data;

    },

    /**

     * desc : index 위치의 데이터 반환

     * date : 2016.04.25

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param index : 위치

     * @return {Number}

     */

    getIndexData: function(dataNum, index) {

      var index_data = {};

      if (dataNum == 1) {

        index_data = this._data1[index];

      } else if (dataNum == 2) {

        index_data = this._data2[index];

      }

      return index_data;

    },

    /**

     * desc : 마지막 데이터 반환

     * date : 2016.04.25

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param exceptflag : 빈데이터 제외 flag(true: 제외, false: 포함, default: true)

     * @return

     */

    getLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }

      var data = this.getData(dataNum);

      var last_len = data.length - 1;

      // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

      if (exceptFlag && this._exceptIdx[dataNum - 1] != 0) {

        last_len = this._exceptIdx[dataNum - 1] - 1;

      }

      return data[last_len];

    },

    /**

     * desc : 빈데이터 시작 IDX 반환

     * date : 2016.04.25

     * 

     * @param : 가져올 데이터의 index

     * @return {Number}

     */

    getExceptIdx: function(dataNum) {

      return this._exceptIdx[dataNum - 1];

    }

  };



  /**

   * desc : roc 데이터 객체(roc)

   * date : 2015.07.22

   * 

   */

  var rocData = function(chart, seqId, chartData, day, signal) {

	this._chart = chart;

    this._type = 'roc';

    this._id = seqId;

    this._data1 = []; // roc

    this._data2 = []; // 시그널선

    this._day = day; // 기간

    this._signal = signal; // signal



    this._exceptIdx = [];

    this.arr_roc = [];

    this.arr_signal = [];



    this.init();

    this.setData(chartData);

  }

  rocData.prototype = {

    init: function() {

      this._exceptIdx[0] = 0;

      this._exceptIdx[1] = 0;



      this.arr_roc = [];

      this.arr_signal = [];

    },

    /**

     * desc : 타입 리턴

     * date : 2015.07.22

     * 

     * @return {String}

     */

    getType: function() {

      return this._type;

    },

    /**

     * desc: id 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getId: function() {

      return this._id;

    },

    /**

     * desc: 기간 리턴

     * date : 2015.07.22

     * 

     * @return

     */

    getDay: function() {

      return this._day;

    },

    /**

     * desc : 초기 전체 데이터 가공

     * date : 2015.07.22

     * 

     * ROC (Price Rate Of Change)계산식

     * roc = 100*(당일종가-n일전종가)/n일전종가 (기본설정값 : 기간 12일, 시그널 9일 고정)

     * @param chartData : 차트 데이터

     */

    setData: function(chartData) {

      if (chartData != null && chartData.length > 0) {

        var roc_val = 0;

        for (var i = this._day, len = chartData.length; i < len; i++) {

          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

            // roc구하기

            roc_val = Number(100 * (chartData[i][4] - chartData[i - this._day][4]) / chartData[i - this._day][4]);

            this.arr_roc[i] = roc_val;

            this._data1.push([Number(chartData[i][0]), Number(roc_val.toFixed(2))]);

            this._exceptIdx[0]++;



            // 시그널선 계산

            var signal_day = this._signal;

            if (i == this._day) { // i가 12 일때, 초기값은 roc_val 값을 그대로 사용

              this.arr_signal[i] = roc_val;

            } else { // i가 10 보다 클때

              //this.arr_signal[i] = (roc_val * (2 / (signal_day + 1))) + this.arr_signal[i - 1] * (1 - (2 / (signal_day + 1)));

            	this.arr_signal[i] = nexChartUtils.calcSma(this.arr_roc,0,i,signal_day);

            }



            if (i >= this._day + signal_day - 1) { // i가 20 또는 20 보다 클때

              var signal_val = this.arr_signal[i];

              this._data2.push([Number(chartData[i][0]), Number(signal_val.toFixed(2))]);

              this._exceptIdx[1]++;

            }

          } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

            this._data1.push([Number(chartData[i][0]), null]);

            this._data2.push([Number(chartData[i][0]), null]);

            this.arr_signal[i] = 0;

          }

          /*

           * console.log( + i + "//" + chartData[i][6] + "//" //+

           * chartData[i][1] + "//" + chartData[i][2] + "//" + chartData[i][3] + "//" + chartData[i][4] + "//" + roc_val + "//"

           * + signal_val );

           */

        }

      }

    },

    /**

     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2015.07.22

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      var data_arr = [this._data1, this._data2];

      for (var i = 0; i < 2; i++) {

        var data = data_arr[i];

        data[this._exceptIdx[i]][0] = nexUtils.date2Utc(datePoint);



        for (var j = this._exceptIdx[i] + 1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {

          if (interval == 'MINUTE' || interval == 'HOURS') {

            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

          } else {

            data[j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

          }

        }

      }

    },

    /**

     * desc : 한건의 데이터 추가

     * date : 2015.07.22

     * 

     * @param pointData : 한건의 데이터

     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) { // 빈데이터 추가

        this._data1.push([Number(pointData[0]), null]);

        this._exceptIdx[0]++;

        this._data2.push([Number(pointData[0]), null]);

        this._exceptIdx[1]++;

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2015.07.22

     * 

     * @param point : 업데이트될 위치(index)

     * @param pointData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     */

    updatePointData: function(point, chartData, exceptFlag) {

      if (chartData != null && chartData.length > 0) {

        var date_utc_time = chartData[point][0];



        // roc구하기 (당일종가 / n일전종가 ) * 100

        var roc_val = Number(100*(chartData[point][4] - chartData[point - this._day][4]) / chartData[point - this._day][4] );

        this.arr_roc[point] = roc_val;

        this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), Number(roc_val.toFixed(2))];



        // 시그널선 계산

        var signal_day = this._signal;

        if (point == this._day) { // i가 12 일때, 초기값은 roc_val 값을 그대로 사용

          this.arr_signal[point] = roc_val;

        } else { // i가 10 보다 클때

          //this.arr_signal[point] = (roc_val * (2 / (signal_day + 1))) + this.arr_signal[point - 1] * (1 - (2 / (signal_day + 1)));

        	this.arr_signal[point] = nexChartUtils.calcSma(this.arr_roc,0,point,signal_day);

        }



        if (point >= this._day + signal_day - 1) { // i가 20 또는 20 보다 클때

          var signal_val = this.arr_signal[point];

          this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point] = [Number(date_utc_time), Number(signal_val.toFixed(2))];

        }

      }

    },

    /**

     * desc : 전체 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @return {Array}

     */

    getData: function(dataNum) {

      var data = [];

      if (dataNum == 1) {

        data = this._data1;

      } else if (dataNum == 2) {

        data = this._data2;

      }

      return data;

    },

    /**

     * desc : index 위치의 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param index : 위치

     * @return {Number}

     */

    getIndexData: function(dataNum, index) {

      var index_data = {};

      if (dataNum == 1) {

        index_data = this._data1[index];

      } else if (dataNum == 2) {

        index_data = this._data2[index];

      }

      return index_data;

    },

    /**

     * desc : 마지막 데이터 반환

     * date : 2015.07.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param exceptflag : 빈데이터 제외 flag(true: 제외, false: 포함, default: true)

     * @return

     */

    getLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }

      var data = this.getData(dataNum);

      var last_len = data.length - 1;

      // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

      if (exceptFlag && this._exceptIdx[dataNum - 1] != 0) {

        last_len = this._exceptIdx[dataNum - 1] - 1;

      }

      return data[last_len];

    },

    /**

     * desc : 빈데이터 시작 IDX 반환

     * date : 2015.07.22

     * 

     * @param : 가져올 데이터의 index

     * @return {Number}

     */

    getExceptIdx: function(dataNum) {

      return this._exceptIdx[dataNum - 1];

    }

  };

  

  /**

   * desc : RSI 데이터 객체(rsi)

   * date : 2016.04.22

   * 

   */

  var rsiData = function(chart, seqId, chartData, day, signal) {

	this._chart = chart;

    this._type = 'rsi';

    this._id = seqId;

    this._data1 = []; // rsi

    this._data2 = []; // 시그널선

    this._day = day; // 기간

    this._signal = signal;



    this._exceptIdx = [];



    this.arr_rsi = [];

    this.arr_signal = [];



    this.init();

    this.setData(chartData);

  }

  rsiData.prototype = {

    init: function() {

      this._exceptIdx[0] = 0;

      this._exceptIdx[1] = 0;



      this.arr_rsi = [];

      this.arr_signal = [];

    },

    /**

     * desc : 타입 리턴

     * date : 2016.04.22

     * 

     * @return {String}

     */

    getType: function() {

      return this._type;

    },

    /**

     * desc: id 리턴

     * date : 2016.04.22

     * 

     * @return

     */

    getId: function() {

      return this._id;

    },

    /**

     * desc: 기간 리턴

     * date : 2016.04.22

     * 

     * @return

     */

    getDay: function() {

      return this._day;

    },

    /**

     * desc : 초기 전체 데이터 가공

     * date : 2016.04.22

     * 

     * RSI 계산식

     * RS = n일간종가평균상승폭 / n일간종가평균하락폭

	 * RSI = 100 - 100/(1+RS) 

	 * 

	 * 또는 (식 변환)

	 * 

	 * RSI = n일간상승폭합계 / (n일간상승폭합계 +  n일간하락폭합계) *100

	 * 

     * @param chartData : 차트 데이터

     */

    setData: function(chartData) {

      if (chartData != null && chartData.length > 0) {

        var rsi_val = 0;

        for (var i = this._day, len = chartData.length; i < len; i++) {

          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

        	rsi_val = nexChartUtils.getSumUp(i,this._day,chartData) / (nexChartUtils.getSumUp(i,this._day,chartData) + nexChartUtils.getSumDown(i,this._day,chartData)) *100;

        	

        	this.arr_rsi[i] = rsi_val;

            this._data1.push([Number(chartData[i][0]), Number(rsi_val.toFixed(2))]);

            this._exceptIdx[0]++;



            // 시그널선 계산 (시그널 기간설정값 signal_day = 9일 고정)

            var signal_day = this._signal;

            if (i == this._day) { // i가 12 일때, 초기값은 roc_val 값을 그대로 사용

              this.arr_signal[i] = rsi_val;

            } else { // i가 10 보다 클때

              //this.arr_signal[i] = (rsi_val * (2 / (signal_day + 1))) + this.arr_signal[i - 1] * (1 - (2 / (signal_day + 1)));

                this.arr_signal[i] = nexChartUtils.calcSma(this.arr_rsi,0,i,signal_day);

            }



            if (i >= this._day + signal_day - 1) { // i가 20 또는 20 보다 클때

              var signal_val = this.arr_signal[i];

              this._data2.push([Number(chartData[i][0]), Number(signal_val.toFixed(2))]);

              this._exceptIdx[1]++;

            }

          } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

            this._data1.push([Number(chartData[i][0]), null]);

            this._data2.push([Number(chartData[i][0]), null]);

            this.arr_signal[i] = 0;

          }

          /*

           * console.log( + i + "//" + chartData[i][6] + "//" //+

           * chartData[i][1] + "//" + chartData[i][2] + "//" + chartData[i][3] + "//" + chartData[i][4] + "//" + rsi_val + "//"

           * + signal_val );

           */

        }

      }

    },

    /**

     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2016.04.22

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      var data_arr = [this._data1, this._data2];

      for (var i = 0; i < 2; i++) {

        var data = data_arr[i];

        data[this._exceptIdx[i]][0] = nexUtils.date2Utc(datePoint);



        for (var j = this._exceptIdx[i] + 1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {

          if (interval == 'MINUTE' || interval == 'HOURS') {

            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

          } else {

            data[j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

          }

        }

      }

    },

    /**

     * desc : 한건의 데이터 추가

     * date : 2016.04.22

     * 

     * @param pointData : 한건의 데이터

     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) { // 빈데이터 추가

        this._data1.push([Number(pointData[0]), null]);

        this._exceptIdx[0]++;

        this._data2.push([Number(pointData[0]), null]);

        this._exceptIdx[1]++;

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2016.04.22

     * 

     * @param point : 업데이트될 위치(index)

     * @param pointData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     */

    updatePointData: function(point, chartData, exceptFlag) {

      if (chartData != null && chartData.length > 0) {

        var date_utc_time = chartData[point][0];



        // roc구하기 (당일종가 / n일전종가 ) * 100

   	 	var rsi_val = nexChartUtils.getSumUp(point,this._day,chartData) / (nexChartUtils.getSumUp(point,this._day,chartData) + nexChartUtils.getSumDown(point,this._day,chartData)) *100;

   	 	this.arr_rsi[point] = rsi_val;

        this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), Number(rsi_val.toFixed(2))];



        // 시그널선 계산 (시그널 기간설정값 signal_day = 9일 고정)

        var signal_day = this._signal;

        if (point == this._day) { // i가 12 일때, 초기값은 roc_val 값을 그대로 사용

          this.arr_signal[point] = rsi_val;

        } else { // i가 10 보다 클때

          //this.arr_signal[point] = (rsi_val * (2 / (signal_day + 1))) + this.arr_signal[point - 1] * (1 - (2 / (signal_day + 1)));

        	this.arr_signal[point] = nexChartUtils.calcSma(this.arr_rsi,0,point,signal_day);

        }



        if (point >= this._day + signal_day - 1) { // i가 20 또는 20 보다 클때

          var signal_val = this.arr_signal[point];

          this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point] = [Number(date_utc_time), Number(signal_val.toFixed(2))];

        }

      }

    },

    /**

     * desc : 전체 데이터 반환

     * date : 2016.04.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @return {Array}

     */

    getData: function(dataNum) {

      var data = [];

      if (dataNum == 1) {

        data = this._data1;

      } else if (dataNum == 2) {

        data = this._data2;

      }

      return data;

    },

    /**

     * desc : index 위치의 데이터 반환

     * date : 2016.04.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param index : 위치

     * @return {Number}

     */

    getIndexData: function(dataNum, index) {

      var index_data = {};

      if (dataNum == 1) {

        index_data = this._data1[index];

      } else if (dataNum == 2) {

        index_data = this._data2[index];

      }

      return index_data;

    },

    /**

     * desc : 마지막 데이터 반환

     * date : 2016.04.22

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param exceptflag : 빈데이터 제외 flag(true: 제외, false: 포함, default: true)

     * @return

     */

    getLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }

      var data = this.getData(dataNum);

      var last_len = data.length - 1;

      // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

      if (exceptFlag && this._exceptIdx[dataNum - 1] != 0) {

        last_len = this._exceptIdx[dataNum - 1] - 1;

      }

      return data[last_len];

    },

    /**

     * desc : 빈데이터 시작 IDX 반환

     * date : 2016.04.22

     * 

     * @param : 가져올 데이터의 index

     * @return {Number}

     */

    getExceptIdx: function(dataNum) {

      return this._exceptIdx[dataNum - 1];

    }

  };

  

  /**

   * desc : 이격도 데이터 객체

   * date : 2016.04.22

   * 

   */

  var disData = function(chart, seqId, chartData, disNums) {

	this._chart = chart;

    this._type = 'dis';

    this._id = seqId;

    this._data1 = [];

    this._data2 = [];

    this._data3 = [];

    this._data4 = [];

    this._dataDisNums = disNums;



    this._exceptIdx = 0;



    this.init();

    this.setData(chartData);

  }

  disData.prototype = {

    init: function() {

      this._exceptIdx = 0;

    },

    /**

     * desc : 타입 리턴

     * date : 2016.04.22

     * 

     * @return {String}

     */

    //

    getType: function() {

      return this._type;

    },

    /**

     * desc: id 리턴

     * date : 2016.04.22

     * 

     * @return

     */

    getId: function() {

      return this._id;

    },

    /**

     * desc : 초기 전체 데이터 가공

     * date : 2016.04.22

     * 이격도

     * (당일주가/당일 이동평균주가) * 100

     * 

     * @param chartData : 차트 데이터

     */

    setData: function(chartData) {

      if (chartData != null && chartData.length > 0) {

        var data_sum1 = 0;

        var data_sum2 = 0;

        var data_sum3 = 0;

        var data_sum4 = 0;

        

        var dis_val1 = 0;

        var dis_val2 = 0;

        var dis_val3 = 0;

        var dis_val4 = 0;



        for (var i = 0, len = chartData.length; i < len; i++) {

          // 빈데이터(현재일 + 26일) 있을 경우 빈데이터 제외하고 데이터 처리

          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

            if (i >= this._dataDisNums[0] - 1) { // 이격1

              data_sum1 += chartData[i][4];

              if (i - (this._dataDisNums[0] - 1) > 0) {

                data_sum1 -= chartData[i - this._dataDisNums[0]][4];

              }

              dis_val1 = (chartData[i][4] / ( data_sum1 / this._dataDisNums[0]) ) * 100; // 이격 지수

              this._data1.push([Number(chartData[i][0]), Number(dis_val1)]);

            } else {

              data_sum1 += chartData[i][4];

              this._data1.push([Number(chartData[i][0]), null]);

            }



            if (i >= this._dataDisNums[1] - 1) { // 이격2

              data_sum2 += chartData[i][4];

              if (i - (this._dataDisNums[1] - 1) > 0) {

                data_sum2 -= chartData[i - this._dataDisNums[1]][4];

              }

              dis_val2 = (chartData[i][4] / ( data_sum2 / this._dataDisNums[1]) ) * 100; // 이격 지수

              this._data2.push([Number(chartData[i][0]), Number(dis_val2)]);

            } else {

              data_sum2 += chartData[i][4];

              this._data2.push([Number(chartData[i][0]), null]);

            }



            if (i >= this._dataDisNums[2] - 1) { // 이격3

              data_sum3 += chartData[i][4];

              if (i - (this._dataDisNums[2] - 1) > 0) {

                data_sum3 -= chartData[i - this._dataDisNums[2]][4];

              }

              dis_val3 = (chartData[i][4] / ( data_sum3 / this._dataDisNums[2]) ) * 100; // 이격 지수

              this._data3.push([Number(chartData[i][0]), Number(dis_val3)]);

            } else {

              data_sum3 += chartData[i][4];

              this._data3.push([Number(chartData[i][0]), null]);

            }



            if (i >= this._dataDisNums[3] - 1) { // 이격4

              data_sum4 += Number(chartData[i][4]);

              if (i - (this._dataDisNums[3] - 1) > 0) {

                data_sum4 -= chartData[i - this._dataDisNums[3]][4];

              }

              dis_val4 = (chartData[i][4] / ( data_sum4 / this._dataDisNums[3]) ) * 100; // 이격 지수

              this._data4.push([Number(chartData[i][0]), Number(dis_val4)]);

            } else {

              data_sum4 += Number(chartData[i][4]);

              this._data4.push([Number(chartData[i][0]), null]);

            }

          

            this._exceptIdx++;



          } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

            this._data1.push([Number(chartData[i][0]), null]);

            this._data2.push([Number(chartData[i][0]), null]);

            this._data3.push([Number(chartData[i][0]), null]);

            this._data4.push([Number(chartData[i][0]), null]);

          }

          /*

          console.log(i + "//" + chartData[i][6] + "//" + chartData[i][1] + "//" + chartData[i][2] + "//" + chartData[i][3] + "//" + chartData[i][4] + "//"

          + dataSum1 + "//" + dataSum2 + "//" + data_sum3 + "//" + data_sum4 );

          */

        }

      }

    },

    /**

     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2016.04.22

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      var data_arr = [this._data1, this._data2, this._data3, this._data4, this._data5];

      for (var i = 0; i < data_arr.length; i++) {

        var data = data_arr[i];

        data[this._exceptIdx+1][0] = nexUtils.date2Utc(datePoint);



        for (var j = this._exceptIdx+1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {

          if (interval == 'MINUTE' || interval == 'HOURS') {

            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

          } else {

            data[j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

          }

        }

      }

    },

    /**

     * desc : 한건의 데이터 추가

     * date : 2016.04.22

     * 

     * @param pointData : 한건의 데이터

     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) { // 빈데이터 추가

        this._data1.push([Number(pointData[0]), null]);

        this._data2.push([Number(pointData[0]), null]);

        this._data3.push([Number(pointData[0]), null]);

        this._data4.push([Number(pointData[0]), null]);

        this._exceptIdx++;

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2016.04.22

     * 

     * @param point : 업데이트될 위치(index)

     * @param chartData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     */

    updatePointData: function(point, chartData, exceptFlag) {

      if (chartData != null && chartData.length > 0) {

        if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

          exceptFlag = false;

        }

        var data_sum1 = 0;

        var data_sum2 = 0;

        var data_sum3 = 0;

        var data_sum4 = 0;

        var data_sum5 = 0;

        

        var dis_val1 = 0;

        var dis_val2 = 0;

        var dis_val3 = 0;

        var dis_val4 = 0;

        

        var date_utc_time = chartData[point][0];



        if (point + 1 >= this._dataDisNums[0]) {

          for (var i = 0; i < this._dataDisNums[0]; i++) {

            data_sum1 += chartData[point - i][4];

          }

          dis_val1 = (chartData[point][4] / ( data_sum1 / this._dataDisNums[0]) ) * 100; // 이격 지수



          this._data1[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), Number(dis_val1)];

        } else {

          this._data1[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), null];

        }



        if (point + 1 >= this._dataDisNums[1]) {

          for (var i = 0; i < this._dataDisNums[1]; i++) {

            data_sum2 += chartData[point - i][4];

          }

          dis_val2 = (chartData[point][4] / ( data_sum2 / this._dataDisNums[1]) ) * 100; // 이격 지수

          this._data2[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), Number(dis_val2)];

        } else {

          this._data2[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), null];

        }



        if (point + 1 >= this._dataDisNums[2]) {

          for (var i = 0; i < this._dataDisNums[2]; i++) {

            data_sum3 += chartData[point - i][4];

          }

          dis_val3 = (chartData[point][4] / ( data_sum3 / this._dataDisNums[2]) ) * 100; // 이격 지수

          this._data3[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), Number(dis_val3)];

        } else {

          this._data3[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), null];

        }



        if (point + 1 >= this._dataDisNums[3]) {

          for (var i = 0; i < this._dataDisNums[3]; i++) {

            data_sum4 += chartData[point - i][4];

          }

          dis_val4 = (chartData[point][4] / ( data_sum4 / this._dataDisNums[3]) ) * 100; // 이격 지수

          this._data4[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), Number(dis_val4)];

        } else {

          this._data4[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), null];

        }

      }

    },

    /**

     * 차트별 전체 데이터 리턴

     * @param dataNum

     * @return {Array}

     */

    getData: function(dataNum) {

      var data = [];

      if (dataNum == 1) {

        data = this._data1;

      } else if (dataNum == 2) {

        data = this._data2;

      } else if (dataNum == 3) {

        data = this._data3;

      } else if (dataNum == 4) {

        data = this._data4;

      } 

      return data;

    },

    /**

     * 차트별 index 위치의 데이터 리턴.

     * @param dataNum

     * @param index

     * @return

     */

    getIndexData: function(dataNum, index) {

      var data = this.getData(dataNum);

      return data[index];

    },

    /**

     * 차트별 마지막 데이터 리턴

     * @param dataNum

     * @param exceptFlag: 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     * @return

     */

    getLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }

      var data = this.getData(dataNum);

      var last_len = data.length - 1;

      // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

      if (exceptFlag && this._exceptIdx != 0) {

        last_len = this._exceptIdx - 1;

      }

      return data[last_len];

    },

    /**

     * desc : 빈데이터 시작 IDX 반환

     * date : 2016.04.22

     * 

     * @return {Number}

     */

    getExceptIdx: function() {

      return this._exceptIdx;

    }

  };

  

  	/**

  	 * desc : DMI 데이터 객체(dmi)

  	 * date : 2016.04.26

  	 * 

  	 */

    var dmiData = function(chart, seqId, chartData, day) {

		this._chart = chart;

		this._type = 'dmi';

		this._id = seqId;

		this._data1 = []; // UpDI

		this._data2 = []; // DownDI

		this._day = day; // 기간

		

		this._PDM = [];

		this._MDM = [];

		this._TR = [];

		

		this._exceptIdx = [];

		

		this.init();

		this.setData(chartData);

    };

    

    dmiData.prototype = {

		init: function() {

			this._exceptIdx[0] = 0;

			this._exceptIdx[1] = 0;

			

			this._PDM = [];

			this._MDM = [];

			this._TR = [];

		},

		/**

	     * desc : 타입 리턴

	     * date : 2016.04.26

	     * 

	     * @return {String}

	     */

	    getType: function() {

	    	return this._type;

	    },

	    /**

	     * desc: id 리턴

	     * date : 2016.04.26

	     * 

	     * @return

	     */

	    getId: function() {

	    	return this._id;

	    },

	    /**

	     * desc: 기간 리턴

	     * date : 2016.04.26

	     * 

	     * @return

	     */

	    getDay: function() {

	    	return this._day;

	    },

	    /**

	     * desc : 초기 전체 데이터 가공

	     * date : 2016.04.26

	     * 

	     * PDM = (당일고가-전일고가 > 0) 이고 (당일고가-전일고가 > 전일저가-당일저가) 이면, (당일고가-전일고가) 이고, 그 이외의 경우는 0.

	     * MDM = (전일저가-당일저가 > 0) 이고 (당일고가-전일고가 < 전일저가-당일저가) 이면, (전일저가-당일저가) 이고, 그 이외의 경우는 0.

	     * TR(True Range) = MAX(고가-저가,(전일종가-당일고가)의 절대값,(전일종가-당일저가)의 절대값)

	     * PDMn = (PDM)의 n일 단순이동평균

	     * MDMn = (MDM)의 n일 단순이동평균

	     * TRn = (TR)의 n일 단순이동평균

	     * PDI = (PDMn) / (TRn) 

	     * MDI = (MDMn) / (TRn)

	     * 

	     * @param chartData : 차트 데이터

	     */

	    setData: function(chartData) {

	    	if (chartData != null && chartData.length > 0) {

	    		for (var i = 0, len = chartData.length; i < len; i++) {

	    			if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

	    				

	    				var PDM,MDM,TR,TRn,PDMn,MDMn,PDI,MDI;

	    				

	    				if(i == 0) {

	    					PDM = 0; MDM = 0; TR = 0;

	    				} else {

	    					var tempPDM = Number(chartData[i][2]) - Number(chartData[i - 1][2]); // 당일고가 - 전일고가

	    					var tempMDM = Number(chartData[i - 1][3]) - Number(chartData[i][3]); // 전일저가 - 당일저가

	    					

	    					PDM = 0;

	    					if (tempPDM > 0 && tempPDM > tempMDM) {

	    						PDM = tempPDM;

	    					} 

	    					

	    					MDM = 0;

	    					if (tempMDM > 0 && tempPDM < tempMDM) {

	    						MDM = tempMDM;

	    					}

	    					

	    					TR = 0;

	    					var tempTR1 = (Number(chartData[i][2]) - Number(chartData[i][3])); // 당일고가 - 당일저가

		    	            var tempTR2 = Math.abs(Number(chartData[i - 1][4]) - Number(chartData[i][2])); // 전일종가 - 당일고가

		    	            var tempTR3 = Math.abs(Number(chartData[i - 1][4]) - Number(chartData[i][3])); // 전일종가 - 당일저가

	    					TR=Math.max(tempTR1,tempTR2,tempTR3);

	    				}

	    				

    					this._PDM[i] = PDM;

    					this._MDM[i] = MDM;

    					this._TR[i] = TR;

	    				

    					if(i >= this._day) { // i가 14 또는 14 보다 클때

    						PDMn = nexChartUtils.calcSma(this._PDM,0,i,this._day);

    						MDMn = nexChartUtils.calcSma(this._MDM,0,i,this._day);

    						TRn = nexChartUtils.calcSma(this._TR,0,i,this._day);



    						// PDI, MDI

    						PDI = PDMn * 100 / TRn; // 0/0 일경우 0 

    						MDI = MDMn * 100 / TRn;

    						

    						this._data1.push([Number(chartData[i][0]), Number(PDI.toFixed(2))]);

    						this._data2.push([Number(chartData[i][0]), Number(MDI.toFixed(2))]);

	    					this._exceptIdx[0]++;

	    					this._exceptIdx[1]++;

    					}

	    			} else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {

	    				this._data1.push([Number(chartData[i][0]), null]);

	    				this._data2.push([Number(chartData[i][0]), null]);

	    			}

		          /*

		           * console.log( + i + "//" + chartData[i][6] + "//" //+

		           * chartData[i][1] + "//" + chartData[i][2] + "//" + chartData[i][3] + "//" + chartData[i][4] + "//" + rsi_val + "//"

		           * + signal_val );

		           */

	    		}

	    	}

	    },

    /**

     * desc :일, 주, 월, 분, 시 (월 or 날짜 변경시 처리)

     * date : 2016.04.22

     * 

     * @param datePoint

     * @param interval : 기간('dd','week','mm','HOURS','MINUTE')

     * @param unit

     */

    datePointChangeData: function(datePoint, interval, unit) {

      var data_arr = [this._data1, this._data2];

      for (var i = 0; i < 2; i++) {

        var data = data_arr[i];

        data[this._exceptIdx[i]][0] = nexUtils.date2Utc(datePoint);



        for (var j = this._exceptIdx[i] + 1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {

          if (interval == 'MINUTE' || interval == 'HOURS') {

            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));

          } else {

            data[j][0] = nexUtils.date2Utc(nexUtils.addDateFullTime(datePoint, interval, unit * up_cnt));

          }

        }

      }

    },

    /**

     * desc : 한건의 데이터 추가

     * date : 2016.04.26

     * 

     * @param pointData : 한건의 데이터

     */

    addPointData: function(pointData) {

      if (pointData != null && pointData.length > 0) { // 빈데이터 추가

        this._data1.push([Number(pointData[0]), null]);

        this._exceptIdx[0]++;

        this._data2.push([Number(pointData[0]), null]);

        this._exceptIdx[1]++;

      }

    },

    /**

     * desc : 한건의 데이터 수정

     * date : 2016.04.22

     * 

     * @param point : 업데이트될 위치(index)

     * @param pointData : 기본 all 데이터(한개의 데이터가 추가되면 계산하기 위한 이전데이터들이 필요하여 전체를 받아서 처리)

     * @param exceptFlag : 빈데이터 제외 여부(true: 제외, false: 포함, default: true)

     */

    updatePointData: function(point, chartData, exceptFlag) {

    	var date_utc_time = chartData[point][0];

    	var PDM,MDM,TR,TRn,PDMn,MDMn,PDI,MDI;

			

    	if(point == 0) {

    		PDM = 0; MDM = 0; TR = 0;

		} else {

			var tempPDM = Number(chartData[point][2]) - Number(chartData[point - 1][2]); // 당일고가 - 전일고가

			var tempMDM = Number(chartData[point - 1][3]) - Number(chartData[point][3]); // 전일저가 - 당일저가

			

			PDM = 0;

			if (tempPDM > 0 && tempPDM > tempMDM) {

				PDM = tempPDM;

			} 

			

			MDM = 0;

			if (tempMDM > 0 && tempPDM < tempMDM) {

				MDM = tempMDM;

			}

			

			TR = 0;

			var tempTR1 = (Number(chartData[point][2]) - Number(chartData[point][3])); // 당일고가 - 당일저가

		    var tempTR2 = Math.abs(Number(chartData[point - 1][4]) - Number(chartData[point][2])); // 전일종가 - 당일고가

		    var tempTR3 = Math.abs(Number(chartData[point - 1][4]) - Number(chartData[point][3])); // 전일종가 - 당일저가

			TR=Math.max(tempTR1,tempTR2,tempTR3);

		}

		

		this._PDM[point] = PDM;

		this._MDM[point] = MDM;

		this._TR[point] = TR;

		

		if(point >= this._day) { // i가 14 또는 14 보다 클때

			PDMn = nexChartUtils.calcSma(this._PDM,0,point,this._day);

			MDMn = nexChartUtils.calcSma(this._MDM,0,point,this._day);

			TRn = nexChartUtils.calcSma(this._TR,0,point,this._day);

		

			// PDI, MDI

			PDI = PDMn * 100 / TRn; // 0/0 일경우 0 

			MDI = MDMn * 100 / TRn;

			

			this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), Number(PDI.toFixed(2))];

	        this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point] = [Number(date_utc_time), Number(MDI.toFixed(2))];

		}

	}, 

    /**

     * desc : 전체 데이터 반환

     * date : 2016.04.26

     * 

     * @param dataNum : 가져올 데이터의 index

     * @return {Array}

     */

    getData: function(dataNum) {

      var data = [];

      if (dataNum == 1) {

        data = this._data1;

      } else if (dataNum == 2) {

        data = this._data2;

      }

      return data;

    },

    /**

     * desc : index 위치의 데이터 반환

     * date : 2016.04.26

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param index : 위치

     * @return {Number}

     */

    getIndexData: function(dataNum, index) {

      var index_data = {};

      if (dataNum == 1) {

        index_data = this._data1[index];

      } else if (dataNum == 2) {

        index_data = this._data2[index];

      }

      return index_data;

    },

    /**

     * desc : 마지막 데이터 반환

     * date : 2016.04.26

     * 

     * @param dataNum : 가져올 데이터의 index

     * @param exceptflag : 빈데이터 제외 flag(true: 제외, false: 포함, default: true)

     * @return

     */

    getLastData: function(dataNum, exceptFlag) {

      if (typeof exceptFlag == 'undefined' || exceptFlag == null) {

        exceptFlag = true;

      }

      var data = this.getData(dataNum);

      var last_len = data.length - 1;

      // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅

      if (exceptFlag && this._exceptIdx[dataNum - 1] != 0) {

        last_len = this._exceptIdx[dataNum - 1] - 1;

      }

      return data[last_len];

    },

    /**

     * desc : 빈데이터 시작 IDX 반환

     * date : 2016.04.26

     * 

     * @param : 가져올 데이터의 index

     * @return {Number}

     */

    getExceptIdx: function(dataNum) {

      return this._exceptIdx[dataNum - 1];

    }

  };



  window.nexChart = nexChart;





// ********************* end nexChart ***********************

