// 2016.01.18 수정
(function(window, $, undefined) { 
  /**
   * desc : WTS 차트 객체
   * date : 2015.07.22
   * author : 김행선
   * @param options.data 		: 차트 데이터 
   * @param options.renderTo 	: 차트 위치(Element node) 
   * @param options.screenNum 	: 화면 번호
   * @param options.monthSect 	: 주기 (1=분봉, 2=일봉, 3=주봉, 4=월봉, 7=시봉) 
   * @param options.width 		: width 값 (px)
   * @param options.height 		: height 값 (px)
   * @param options.xRange 		: 최초 navigator range(3*30*24*3600*1000==3개월) 
   * @param options.chartOptions : 추가 옵션
   */
  var nexChart = function(options) {
	// 전역 변수
    this._chart;			// HighChart Object
    this._data;				// 차트 데이터    this._dataLen; 			// _data.length 값    this._renderTo; 		// 차트 위치(Element node)    this._screenNum; 		// 화면 번호    this._monthSect;		// 주기(1=분봉, 2=일봉, 3=주봉, 4=월봉, 7=시봉)     this._chartWidth;		// width 값(px)    this._chartHeight;		// height 값(px)    this._seriesData;		// 현재 생성되어 있는 series    this._seriesDataCnt;	// 현재 생성되어 있는 series 개수    this._yAxisCnt; 		// 현재 생성되어 있는 yAxis 개수(최초 y축은 옵션에서 하나 지정(필수))    this._exceptIdx; 		// 빈데이터 시작 IDX(현재일 이후 + 26일)    this._xRange; 			// 초기 navigator range(3*30*24*3600*1000==3개월)    this._colors;			// 라인 색상	this._chartOptions; 	// 추가 옵션	this._defaultVar;		// 차트 수치값	this.init(options);
  }
  nexChart.prototype = {
    /**
     * desc : 초기화     * date : 2015.07.22     */    init: function(options) {      this._data 			= options.data;       this._renderTo 		= options.renderTo[0];      this._monthSect 		= options.monthSect || '2';      this._chartWidth 		= options.width || 600;      this._chartHeight		= options.height || 470;      this._dataLen 		= options.data.length;       //this._series 		= options.series || [];        this._screenNum 		= options.screenNum;      this._seriesData 		= [];       this._seriesDataCnt 	= 0;      this._yAxisCnt 		= 1;      this._exceptIdx 		= 0;      this._xRange 			= options.xRange || this._dataLen > 46 ? this._data[this._dataLen - 1][0] - this._data[parseInt(this._dataLen / 1.5)][0] : null; 	   //this._xRange 			= options.xRange != null ? options.xRange : 3 * 30 * 24 * 3600 * 1000; // 3달	  this._chartOptions 	= options.chartOptions || null;	  this._colors			= Highcharts.getOptions().colors;	  this._defaultVar 		= { 	   	'candle'	: null,	   	'volume'	: null,	   	'sma'		: [5, 20, 60, 120],	   	'cna'		: [26, 9, 26, 26, 52],	   	'bollinger'	: [20],	   	'envelope'	: [13, 8],	   	'maribbon'	: [5, 1, 15],	   	'macd'		: [12, 26, 9],	   	'slowStc'	: [10, 5, 5],	   	'cci'		: [14], 	   	'mental'	: [10],	   	'adx'		: [14],	   	'obv'		: [9],	   	'sonar'		: [20, 9, 9],	   	'vr'		: [20],	   	'trix'		: [12, 9],	   	'roc'		: [12]	   };
      this._chart			= new Highcharts.StockChart(this.getChartTypeOption(this._renderTo, this._monthSect, this._xRange, this._chartWidth, this._chartHeight, this.chartOptions));
      this.drawTotalChart();
    },
    /**     * desc : 지표 추가     * date : 2015.01.18     */    addChart: function(seriesId, seriesData) {   	 var mainYaxis = ['candle','sma','cna','bollinger','envelope','maribbon'] ;   	 var yAxis, series;   	 if(mainYaxis.indexOf(seriesId) > -1){   		 yAxis = 'mainYaxis';   		    	 } else {   		 yAxis = seriesId+'Yaxis';   		 this.addYAxis(yAxis);   	 }   	 series = seriesId+'Series';   	 this.addSeries(series, yAxis, seriesData);    },
    /**     * desc : _renderTo에 종합 차트 생성     * date : 2015.07.22     */    drawTotalChart: function(){    	//new nexTotalChart(this._renderTo, this._screenNum, this);    	this.addSeries("candleSeries", "mainYaxis", null);    	this.addYAxis("volumeYaxis");    	this.addSeries("volumeSeries", "volumeYaxis", null);    	this.addSeries("smaSeries", "mainYaxis", null);    	this._chart.redraw();    },
    /**     * desc : 사이즈 변경     * date : 2016.04.07     */    setSize: function(width,height) {    	this._chart.setSize(width,height); 	    },
    /**     * desc : 데이터 반환     * date : 2015.07.22     *      * @return _data : 차트 데이터     */    getData: function() {      return this._data;    },
    /**     * desc : 데이터 반환     * date : 2015.07.22     *      * @return _data : 차트 데이터     */    getDataLength: function() {      var rtn_len = this._dataLen;      // 빈데이터(현재일 + 26일) 있을 경우 빈데이터 이전까지 데이터 크기      if (this._exceptIdx != 0) {        rtn_len = this._exceptIdx;      }      return rtn_len;    },
    /**     * desc : 가장 최근 데이터의 UTC 시간 반환     * date : 2015.07.22     *      * @return {number} : UTC 시간     */    getLastDataTimeUtc: function() {      if (this.getDataLength() > 0) {        return this._data[this.getDataLength() - 1][0];        // 빈데이터(현재일 + 26일)가 있을 경우 마지막 날짜로 현재일 세팅        if (this._exceptIdx != 0) {          return this._data[this._exceptIdx - 1][0];        }      }    },
    /**     * desc : 빈 데이터 시작 IDX 반환     * date : 2015.07.22     *      * @return _exceptIdx     */    getExceptIdx: function() {      return this._exceptIdx;    },	
    /**     * desc : 차트 메인 옵션     * date : 2016.01.13     *      * @param typeOptions : 차트 커스텀 옵션, null일 경우 종합차트 옵션값(totChartOptions)으로 셋팅     * @return 차트 옵션 객체     */
    getChartTypeOption: function(renderTo, monthSect, xRange, width, height, customOptions) {    	// 기본옵션    	var defaultOptions = {			  chart: {			  panning: true, //zoom 설정과 연계되는 움직임 설정(zoom을 하지 않을경우 이것두 false로 설정해야 움직임이 없어진다)	          renderTo: renderTo,	          zoomType: 'x', //zoom 설정(x,y,xy)	          height: height,	          width: width
		},
		tooltip: {        crosshairs: [true, false], //화면에서 마우스 라인        shared: true, //한번의 툴팁으로 여러 그래프를 표현.        positioner: null,        xDateFormat: nexChartUtils.getHederTimeFormat(monthSect)     },     plotOptions: { //series 옵션의 글로벌 선언부(여기 있는 모든 옵션값은 series에 개별 정의가능)          series: {          states: {          hover: {          enabled: false,          lineWidth: 1 //라인에 마우스 올렸을때 크기          }     },     dataGrouping: {    	 enabled: false //데이터 그룹핑 여부 [default(line:avg, colum:sum ...)     }   }},
        xAxis: {
          range: xRange,
          startOnTick: false, // 최초 x라벨 표시 여부(min을 설정하면 이값은 무시된다)
          gridLinedashStyle: 'dot',
          zIndex: 1000, // 대쉬 스타일
          gridLineWidth: 0, // 그리드 라인 크기
          minorTickLength: 0 //보여지는 라벨과 라벨사이의 틱의 갯수
        },
        scrollbar: {
           enabled: true,
           margin: 0
        },
        yAxis: {
          id: 'mainYaxis',
          lineWidth: 1,
          opposite: true, // true:y라벨 오른쪽, false:y라벨 왼쪽
          showFirstLabel: false,
          gridLinedashStyle: 'dot',
          zIndex: 1000, // 대쉬 스타일
          top: 25,
          height: height - 70,
          minorTickLength: 5, // 보여지는 라벨과 라벨사이의 틱의 갯수
          tickPixelInterval: 50,
          labels: {
             enabled: true,
             align: 'left',
             formatter: function() {
               var valueData = this.value;
               return Highcharts.numberFormat(valueData, 0);
             },
             x: 10,
             y: 5
 	 		  }
        },
        rangeSelector: {
           enabled: false
        },
        navigator: {
           enabled: false,
           height: 22,
           margin: 0,
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
 		  legend: {
           enabled: true,
           padding: 0,
           margin: 0,
           x: 0,
           y: -15
        }
	  };
	  
	  if(customOptions != null) {		  
		  defaultOptions = Highcharts.merge(true, defaultOptions, customOptions);
	  }
	  
	  return defaultOptions;
    },
    /**
     * desc : 차트 yAxis 옵션
     * date : 2015.07.22
     * 
     * ex : getChartYAxisOption('volumeYaxis'); -> volumeYaxis 옵션 설정 후 그 값 반환
     * @param axisId : id
     * @return 차트 옵션 객체
     */
    getChartYAxisOption: function(axisId, customOptions) {
      var defaultOptions = {
        id: axisId,
        lineWidth: 1,
        opposite: true, //true:y라벨 오른쪽, false:y라벨 왼쪽
        showFirstLabel: false,
        gridLinedashStyle: 'dot',
        zIndex: 1000, //대쉬 스타일
        gridLineWidth: 1,
        labels: {
          enabled: true,
          align: 'left',
          formatter: function() {
            return nexUtils.numberWithCommas(this.value);
          },
          x: 10,
          y: 5
        },
        offset: 0,
        minorTickLength: 0,
        tickPixelInterval: 30
      };
      
      if(customOptions != null) {		  
 		  defaultOptions = Highcharts.merge(true, defaultOptions, customOptions);
 	   }
      
      return defaultOptions;
    },
    /**
     * desc : SET 라인 색상 (미완료)
     */
    setLineColor: function(type, color) {
   	 
    },
    /**
     * desc : GET 라인 색상
     * date : 2016.01.04
     * 
     * @param type : 라인 TYPE
     * @return {String} : 색상코드
     */
    getLineColor: function(type) {
   	 switch (type) { // 차트별 옵션 적용
          case 'volume': // 거래량( UP )
            return this._colors[0];
          case 'volume1': // 거래량( DOWN )
            return this._colors[1];
          case 'sma1': // 이동평균( 5 이평 )
         	return this._colors[13];
          case 'sma2': // 이동평균( 20 이평 )
         	return this._colors[14];
          case 'sma3': // 이동평균( 60 이평 )
         	return this._colors[15];
          case 'sma4': // 이동평균 ( 120 이평 )
         	return this._colors[16];
          case 'cna1': // 일목균형 ( 기준선 )
         	return this._colors[0];
          case 'cna2': // 일목균형 ( 전환선 )
         	return this._colors[1];
          case 'cna3': // 일목균형 ( 후행스팬 )
         	return this._colors[5];
          case 'cna4': // 일목균형 ( 단기선행스팬 )
         	return this._colors[12];
          case 'cna5': // 일목균형 ( 장기선행스팬 - 단기선행스팬 구름대 )
         	return this._colors[11];
          case 'cna6': // 일목균형 ( 단기선행스팬 - 장기선행스팬 구름대 )
         	return this._colors[12];
          case 'cna7': // 일목균형 ( 장기선행스팬 )
         	return this._colors[11];
          case 'bollinger1': // bollingerBand ( 상한선 )
         	return this._colors[1];
          case 'bollinger2': // bollingerBand ( 중심선 )
         	return this._colors[5];
          case 'bollinger3': // bollingerBand ( 하한선 )
         	return this._colors[0];
          case 'envelope1': // Envelope ( 상한선 )
         	return this._colors[1];
          case 'envelope2': // Envelope ( 중심선 )
         	return this._colors[5];
          case 'envelope3': // Envelope ( 하한선 )
         	return this._colors[0];
          case 'maribbon': // 그물차트
            return this._colors[12];
          case 'macd1': // MACD ( MACD )
            return this._colors[9];
          case 'macd2': // MACD ( Signal )
            return this._colors[1];
          case 'macd3': // MACD ( OSC )
         	return this._colors[2];
          case 'slowstc1': // SlowStc ( Slow %K )
            return this._colors[1];
          case 'slowstc2': // SlowStc ( Slow %D )
            return this._colors[2];
          case 'cci1': // cci
            return this._colors[2];
          case 'cci2': // cci (시그널선)
            return this._colors[9];
          case 'mental1': // 투자심리 ( 심리도 )
            return this._colors[2];
          case 'mental2': // 투자심리 ( 시그널 )
            return this._colors[9];
          case 'adx1': // ADX ( PDI )
            return this._colors[2];
          case 'adx2': // ADX ( MDI )
            return this._colors[9];
          case 'adx3': // ADX ( ADX )
            return this._colors[1];
          case 'obv1': // OBV ( OBV )
            return this._colors[1];
          case 'obv2': // OBV ( 시그널선 )
            return this._colors[9];
          case 'sonar1': // SONAR ( SONAR )
            return this._colors[1];
          case 'sonar2': // SONAR ( Signal )
            return this._colors[9];
          case 'vr': // VR ( VR )
            return this._colors[9];
          case 'trix1': // TRIX ( TRIX )
            return this._colors[1];
          case 'trix2': // TRIX ( Signal )
            return this._colors[9];
          case 'roc1': // ROC ( ROC )
            return this._colors[1];
          case 'roc2': // ROC ( Signal )
            return this._colors[9];
        }
    },
    /**
     * desc : 차트 시리즈(지표,보조차트)별 옵션설정
     * date : 2015.07.22
     * 
     * ex : getChartSeriesOption('candle', 'candleSeries', '가격', 'candleYaxis', {data}, false);
     * @param type : 차트타입
     * @param seriesId : 시리즈 id
     * @param seriesNm : 시리즈명
     * @param yAxisId : 그려질 y축 id
     * @param data : 데이터
     * @param legend : 범례 표현 flag(true, false)
     * @return 차트 옵션 객체
     */
    getChartSeriesOption: function(type, seriesId, seriesNm, yAxisId, data, legend) {
      var show_legend = (legend == false) ? false : true;
      var option = { // 기본 옵션
        type: 'spline',
        id: seriesId,
        name: seriesNm,
        yAxis: yAxisId,
        showInLegend: show_legend,
        data: data.slice(),
        color: this.getLineColor(type),
        tooltip: {
          valueDecimals: 0
        }
      }
      
      // 차트별 옵션 적용
      switch (type) { 
        case 'candle': // 캔들스틱
          option.type = 'candlestick';
          return option;
        case 'volume': // 거래량
          option.type = 'column';
          return option;
        case 'sma1': // 이동평균( 5 이평 )
          return option;
        case 'sma2': // 이동평균( 20 이평 )
          return option;
        case 'sma3': // 이동평균( 60 이평 )
          return option;
        case 'sma4': // 이동평균 ( 120 이평 )
          return option;
        case 'cna1': // 일목균형 ( 기준선 )
          return option;
        case 'cna2': // 일목균형 ( 전환선 )
          return option;
        case 'cna3': // 일목균형 ( 후행스팬 )
          return option;
        case 'cna4': // 일목균형 ( 단기선행스팬 )
          return option;
        case 'cna5': // 일목균형 ( 장기선행스팬 - 단기선행스팬 구름대 )
          option.type = 'columnrange';
          return option;
        case 'cna6': // 일목균형 ( 단기선행스팬 - 장기선행스팬 구름대 )
          option.type = 'columnrange';
          return option;
        case 'cna7': // 일목균형 ( 장기선행스팬 )
          return option;
        case 'bollinger1': // bollingerBand ( 상한선 )
          option.lineWidth = 2;
          return option;
        case 'bollinger2': // bollingerBand ( 중심선 )
          option.lineWidth = 2;
          return option;
        case 'bollinger3': // bollingerBand ( 하한선 )
          option.lineWidth = 2;
          return option;
        case 'envelope1': // Envelope ( 상한선 )
          option.lineWidth = 2;
          return option;
        case 'envelope2': // Envelope ( 중심선 )
          option.lineWidth = 2;
          return option;
        case 'envelope3': // Envelope ( 하한선 )
          option.lineWidth = 2;
          return option;
        case 'maribbon': // 그물차트
          return option;
        case 'macd1': // MACD ( MACD )
          return option;
        case 'macd2': // MACD ( Signal )
          return option;
        case 'macd3': // MACD ( OSC )
          option.type = 'column';
          option.tooltip = {
            pointFormat: ''
          };
          return option;
        case 'slowstc1': // SlowStc ( Slow %K )
			 option.tooltip = {
            valueDecimals: 2
          };
          return option;
        case 'slowstc2': // SlowStc ( Slow %D )
			 option.tooltip = {
            valueDecimals: 2
          };
          return option;
        case 'cci1': // cci
          return option;
        case 'cci2': // cci (시그널선)
          return option;
        case 'mental1': // 투자심리 ( 심리도 )
          return option;
        case 'mental2': // 투자심리 ( 시그널 )
          return option;
        case 'adx1': // ADX ( PDI )
          return option;
        case 'adx2': // ADX ( MDI )
          return option;
        case 'adx3': // ADX ( ADX )
          return option;
        case 'obv1': // OBV ( OBV )
          return option;
        case 'obv2': // OBV ( 시그널선 )
          return option;
        case 'sonar1': // SONAR ( SONAR )
          return option;
        case 'sonar2': // SONAR ( Signal )
          return option;
        case 'vr': // VR ( VR )
          return option;
        case 'trix1': // TRIX ( TRIX )
          return option;
        case 'trix2': // TRIX ( Signal )
          return option;
        case 'roc1': // ROC ( ROC )
          return option;
        case 'roc2': // ROC ( Signal )
          return option;
        default:
          return option;
      }
    },
    /**
     * desc : PlotLine(보조선) 옵션 반환
     * date : 2015.07.22
     * 
     * ex : getPlotLineOption('slowStc');
     * @param type : 화면번호
     * @param axisId : id
     * @return 차트 옵션 객체
     */
    getPlotLineOption: function(type) {
      var lineOptions = [];
      var lineOption = function(value) {
        return {
          color: '#000000',
          value: value,
          dashStyle: 'dashDot',
          zIndex: 1,
          width: 1,
          label: {
            style: {
              font: '11px "맑은 고딕",Dotum,"굴림",Gulim,AppleGothic,Arial,Helvetica,sans-serif',
              color: '#000000'
            },
            text: value
          }
        }
      }
      switch (type) {
        case 'slowStc':
          lineOptions[0] = lineOption(20);
          lineOptions[1] = lineOption(80);
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
          lineOptions[0] = lineOption(20);
          break;
        case 'williams':
          lineOptions[0] = lineOption(-20);
          lineOptions[1] = lineOption(-80);
          break;
        case 'vr':
        case 'roc':
          lineOptions[0] = lineOption(100);
          break;
        case 'obv':
        case 'sonar':
        case 'trix':
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
    addYAxis: function(yAxisId) {
      var option = this.getChartYAxisOption(yAxisId);;
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
    removeYAxis: function(yAxisId) {
      this._chart.get(yAxisId).remove(false);
      this._yAxisCnt--;
      this.reSizeHeight();
    },
    /**
     * desc : 차트 높이값 설정
     * date : 2015.07.22
     * 
     */
    reSizeHeight: function() {
      //모든 yAxis에 대해서 height,top 재수정
      var total_height = this._chartHeight;
      var candle_height = total_height - ((this._yAxisCnt - 1) * 75) - 50;

      this._chart.yAxis[0].update({
        top: 25,
        height: candle_height - 20
      }, false);

      var yAxis = this._chart.yAxis;
      for (var i = 1, cnt = 0, len = yAxis.length; i < len; i++) {
        if (yAxis[i].options.id != 'navigator-y-axis') {
          yAxis[i].update({
            top: candle_height + (cnt * 75) + 10, //secondTop
            height: 78
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
     */
    addSeries: function(seriesId, yAxisId, seriesData) {
      var index = this.getSeriesDataIndex(seriesId);
      var options = [];
      if (seriesData == null) {
      	seriesData = this._defaultVar[seriesId.split('Series')[0]];
      } 
      		
      if (index != null) {
        return;
      }

      switch (seriesId) {
        case 'candleSeries': // 캔들 시리즈 추가
          this._seriesData[this._seriesDataCnt] = new candleData(this, seriesId, this._data);
          this._exceptIdx = this._seriesData[this._seriesDataCnt].getExceptIdx();
          options[0] = this.getChartSeriesOption('candle', seriesId, 'Price', yAxisId, this._seriesData[this._seriesDataCnt].getData());

          break;
        case 'smaSeries': // sma(이동평균) 시리즈 추가.
          var sma_nums = seriesData, //이동평균 수치 배열 (예) [5,20,60,120]
            option1, option2, option3, option4;

          this._seriesData[this._seriesDataCnt] = new smaData(this, seriesId, this._data, sma_nums);
          options[0] = this.getChartSeriesOption('sma1', seriesId + '_1', sma_nums[0].toString(), yAxisId, this._seriesData[this._seriesDataCnt].getData(1));
          options[1] = this.getChartSeriesOption('sma2', seriesId + '_2', sma_nums[1].toString(), yAxisId, this._seriesData[this._seriesDataCnt].getData(2));
          options[2] = this.getChartSeriesOption('sma3', seriesId + '_3', sma_nums[2].toString(), yAxisId, this._seriesData[this._seriesDataCnt].getData(3));
          options[3] = this.getChartSeriesOption('sma4', seriesId + '_4', sma_nums[3].toString(), yAxisId, this._seriesData[this._seriesDataCnt].getData(4));

          break;
        case 'cnaSeries': // cna(일목균형) 시리즈 추가.
          var sma_nums = seriesData; //일목균형 수치 배열 (기준선, 전환선, 후행스팬, 단기선행스팬, 장기선행스팬)

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
          var sma_num = seriesData[0]; // sma_num: 이동평균 수치

          this._seriesData[this._seriesDataCnt] = new bollingerData(this, seriesId, this._data, sma_num);
          options[0] = this.getChartSeriesOption('bollinger1', seriesId + '_1', 'BB_상한선', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));
          options[1] = this.getChartSeriesOption('bollinger2', seriesId + '_2', 'BB_중심선(' + sma_num + ',2)', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));
          options[2] = this.getChartSeriesOption('bollinger3', seriesId + '_3', 'BB_하한선', yAxisId, this._seriesData[this._seriesDataCnt].getData(3));

          break;
        case 'envelopeSeries': // envelope 시리즈 추가.
          var sma_num = seriesData[0], // 이동평균 수치
            factor = seriesData[1]; // 가감값

          this._seriesData[this._seriesDataCnt] = new envelopeData(this, seriesId, this._data, sma_num, factor);
          options[0] = this.getChartSeriesOption('envelope1', seriesId + '_1', 'E_상한선', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));
          options[1] = this.getChartSeriesOption('envelope2', seriesId + '_2', 'E_중심선(' + sma_num + ',' + factor + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));
          options[2] = this.getChartSeriesOption('envelope3', seriesId + '_3', 'E_하한선', yAxisId, this._seriesData[this._seriesDataCnt].getData(3));

          break;
        case 'maribbonSeries': // 그물 시리즈 추가.
          var sma_num = seriesData[0], // 이동평균
            inc = seriesData[1], // 증가값
            rCnt = seriesData[2], // 계수
            option,
            that = this;

          this._seriesData[this._seriesDataCnt] = new maRibbonData(this, seriesId, this._data, sma_num, inc, rCnt);

          for (var i = 0, len = rCnt; i < len; i++) {
            var legend = false;
            if (i == 0) {
              legend = true;
              option = this.getChartSeriesOption('maribbon', seriesId + '_' + (i + 1), 'Moving Average Ribbon(' + sma_num + ',' + inc + ',' + rCnt + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(i), legend);
            } else {
              option = this.getChartSeriesOption('maribbon', seriesId + '_' + (i + 1), 'Moving Average Ribbon' + (i + 1), yAxisId, this._seriesData[this._seriesDataCnt].getData(i), legend);
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
          options[0] = this.getChartSeriesOption('volume', seriesId, 'Volume', yAxisId, this._seriesData[this._seriesDataCnt].getData(), false);

          break;
        case 'macdSeries':
          var emaNum1 = seriesData[0], // 단기이평
            emaNum2 = seriesData[1], // 장기이평
            signal = seriesData[2]; // signal

          this._seriesData[this._seriesDataCnt] = new macdData(this, seriesId, this._data, emaNum1, emaNum2, signal);
          options[0] = this.getChartSeriesOption('macd1', seriesId + '_1', 'MACD(' + emaNum1 + ',' + emaNum2 + ',' + signal + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));
          options[1] = this.getChartSeriesOption('macd2', seriesId + '_2', 'Signal', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));
          options[2] = this.getChartSeriesOption('macd3', seriesId + '_3', 'Osc', yAxisId, this._seriesData[this._seriesDataCnt].getData(3), false);

          break;
        case 'slowStcSeries': // slowStc 시리즈 추가.
          var day = seriesData[0], // 기간
            slowK = seriesData[1], // Slow %K 구간
            slowD = seriesData[2]; // Slow %D 구간

          this._seriesData[this._seriesDataCnt] = new slowStcData(this, seriesId, this._data, day, slowK, slowD);
          options[0] = this.getChartSeriesOption('slowstc1', seriesId + '_1', 'Slow %K(' + day + ',' + slowK + ',' + slowD + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));
          options[1] = this.getChartSeriesOption('slowstc2', seriesId + '_2', 'Slow %D', yAxisId, this._seriesData[this._seriesDataCnt].getData(3));

          break;
        case 'cciSeries': // CCI 시리즈 추가.
          var day = seriesData[0]; // 기간

          this._seriesData[this._seriesDataCnt] = new cciData(this, seriesId, this._data, day);
          options[0] = this.getChartSeriesOption('cci1', seriesId + '_1', 'CCI(' + day + ',' + 9 + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(3));
          options[1] = this.getChartSeriesOption('cci2', seriesId + '_2', 'Signal', yAxisId, this._seriesData[this._seriesDataCnt].getData(4));

          break;
        case 'mentalSeries': // 투자심리 시리즈 추가.
          var day = seriesData[0]; // day

          this._seriesData[this._seriesDataCnt] = new mentalData(this, seriesId, this._data, day);
          options[0] = this.getChartSeriesOption('mental1', seriesId + '_1', 'Investment sentiment(' + day + ',' + 15 + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));
          options[1] = this.getChartSeriesOption('mental2', seriesId + '_2', 'Signal', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

          break;
        case 'adxSeries': //ADX 시리즈 추가.
          var day = seriesData[0] // 기간

          this._seriesData[this._seriesDataCnt] = new adxData(this, seriesId, this._data, day);
          options[0] = this.getChartSeriesOption('adx1', seriesId + '_1', 'PDI', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));
          options[1] = this.getChartSeriesOption('adx2', seriesId + '_2', 'MDI', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));
          options[2] = this.getChartSeriesOption('adx3', seriesId + '_3', 'ADX(' + day + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(3));

          break;
        case 'obvSeries': // OBV 시리즈 추가.
          var day = seriesData[0] // 기간

          this._seriesData[this._seriesDataCnt] = new obvData(this, seriesId, this._data, day);
          options[0] = this.getChartSeriesOption('obv1', seriesId + '_1', 'OBV(' + day + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));
          options[1] = this.getChartSeriesOption('obv2', seriesId + '_2', 'Signal', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

          break;
        case 'sonarSeries': // SONAR 시리즈 추가.
          var emaNum1 = seriesData[0], // emaNum1
            day = seriesData[1], // 기간
            signal = seriesData[2]; //signal

          this._seriesData[this._seriesDataCnt] = new sonarData(this, seriesId, this._data, emaNum1, day, signal);
          options[0] = this.getChartSeriesOption('sonar1', seriesId + '_1', 'SONAR(' + emaNum1 + ',' + signal + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));
          options[1] = this.getChartSeriesOption('sonar2', seriesId + '_2', 'Signal', yAxisId, this._seriesData[this._seriesDataCnt].getData(2), false);

          break;
        case 'vrSeries': //  VR 시리즈 추가.
          var day = seriesData[0]; // 기간

          this._seriesData[this._seriesDataCnt] = new vrData(this, seriesId, this._data, day);
          options[0] = this.getChartSeriesOption('vr', seriesId, 'VR(' + day + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData());

          break;
        case 'trixSeries': // TRIX 시리즈 추가.
          var day = seriesData[0], // 기간
            signal = seriesData[1]; // signal

          this._seriesData[this._seriesDataCnt] = new trixData(this, seriesId, this._data, day, signal);
          options[0] = this.getChartSeriesOption('trix1', seriesId + '_1', 'TRIX(' + day + ',' + signal + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));
          options[1] = this.getChartSeriesOption('trix2', seriesId + '_2', 'Signal', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

          break;
        case 'williamsSeries': // Williams 시리즈 추가.
          var day = seriesData[0] // 기간

          this._seriesData[this._seriesDataCnt] = new williamsData(this, seriesId, this._data, day);
          options[0] = this.getChartSeriesOption('williams', seriesId, 'WILLIAMS`%R(' + day + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData());

          break;
        case 'rocSeries': // ROC 시리즈 추가.
          var day = seriesData[0]; //기간

          this._seriesData[this._seriesDataCnt] = new rocData(this, seriesId, this._data, day);
          options[0] = this.getChartSeriesOption('roc1', seriesId + '_1', 'ROC(' + day + ',' + 9 + ')', yAxisId, this._seriesData[this._seriesDataCnt].getData(1));
          options[1] = this.getChartSeriesOption('roc2', seriesId + '_2', 'Signal', yAxisId, this._seriesData[this._seriesDataCnt].getData(2));

          break;
      }

      if (seriesId == 'maribbonSeries') { // 그물차트일경우 switch문에서 addSeries 처리
        return;
      }

      for (var i = options.length; i--;) { // highchart library의 addSeries 호출
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
        case 'sma': // 라인 4 개
          this._chart.get(seriesId + '_1').remove(false);
          this._chart.get(seriesId + '_2').remove(false);
          this._chart.get(seriesId + '_3').remove(false);
          this._chart.get(seriesId + '_4').remove(false);
          break;
        case 'bollinger': // 라인 3 개
        case 'envelope':
        case 'adx':
          this._chart.get(seriesId + '_1').remove(false);
          this._chart.get(seriesId + '_2').remove(false);
          this._chart.get(seriesId + '_3').remove(false);
          break;
        case 'macd': // 라인 2 개
        case 'slowstc':
        case 'sonar':
        case 'trix':
        case 'mental':
        case 'obv':
        case 'roc':
        case 'cci':
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
    setRealTimeData: function(pointData) {
      //if (pointData != null && pointData.length > 0) {
      if (pointData) {
        var len = this.getDataLength();
        var last_data_time_utc = this.getLastDataTimeUtc();

        if (last_data_time_utc == pointData[0] && len > 0) { // UPD
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
            var lost_time = null;
            var add_time = null;
            var add_date_utc_time = null;
            var add_point_data = [];

            // self._monthSect: 2: 일봉, 3: 주봉, 4: 월봉, 1: 분봉, 7: 시봉
            if (pointData[6] == 2) { // 2: 일봉
              lost_time = Highcharts.dateFormat('%Y%m%d', this._data[this._data.length - 1][0]);
              if (pointData[8].toString().substr(0, 8) != lost_time) { // 일 변경 처리
                lost_time = pointData[8].toString();
                this.datePointChangeData(lost_time, 'dd', 1); // 빈데이터 날짜 변경처리
              }
              add_time = nexUtils.dateAdd(lost_time, 'dd', 1);
            } else if (pointData[6] == 3) { // 3: 주봉
              lost_time = Highcharts.dateFormat('%Y%m%d', this._data[this._data.length - 1][0]);
              if (pointData[8].toString().substr(0, 8) != lost_time) { // 일 변경 처리
                lost_time = pointData[8].toString();
                this.datePointChangeData(lost_time, 'week', 1); // 빈데이터 날짜 변경처리
              }
              add_time = nexUtils.dateAdd(lost_time, 'week', 1);
            } else if (pointData[6] == 4) { // 4: 월봉
              lost_time = Highcharts.dateFormat('%Y%m', this._data[this._data.length - 1][0]);
              if (pointData[8].toString().substr(0, 6) != lost_time) { // 일 변경 처리
                lost_time = pointData[8].toString();
                this.datePointChangeData(lost_time, 'mm', 1); // 빈데이터 날짜 변경처리
              }
              add_time = nexUtils.dateAdd(lost_time, 'mm', 1);
            } else if (pointData[6] == 1) { // 1: 분봉
              lost_time = Highcharts.dateFormat('%Y%m%d%H%M', this._data[this._data.length - 1][0]);
              if (pointData[8].toString().substr(0, 8) != lost_time.substr(0, 8)) { // 일 변경 처리
                lost_time = pointData[8].toString();
                this.datePointChangeData(lost_time, 'MINUTE', 1); // 빈데이터 날짜 변경처리
              }
              add_time = nexChartUtils.getAddTime('MINUTE', lost_time, Number(pointData[7]));
            } else if (pointData[6] == 7) { // 7: 시봉
              lost_time = Highcharts.dateFormat('%Y%m%d%H', this._data[this._data.length - 1][0]);
              if (pointData[8].toString().substr(0, 8) != lost_time.substr(0, 8)) { // 일 변경 처리
                lost_time = pointData[8].toString().substr(0, 10);
                this.datePointChangeData(lost_time, 'HOURS', 1); // 빈데이터 날짜 변경처리
              }
              add_time = nexChartUtils.getAddTime('HOURS', lost_time, Number(pointData[7]) / 60);
            }

            add_date_utc_time = nexUtils.date2Utc(add_time);
            // 날짜 또는 시간,시가,고가,저가,종가,거래량,날짜(테스트)
            add_point_data.push(Number(add_date_utc_time), null, null, null, null, null, Number(add_time), 'except');

            this.addPointData(add_point_data);

            // 제외 idx 증가 및 전체 Len 증가
            this._exceptIdx++;
            this._dataLen++;

            last_data_time_utc = this._data[this._exceptIdx - 1][0];

            // UPD 후 신규데이터 추가
            if (pointData[0] == last_data_time_utc) {
              this._data[len][1] = pointData[1]; // 시가
              this._data[len][2] = pointData[2]; // 고가
              this._data[len][3] = pointData[3]; // 저가
              this._data[len][4] = pointData[4]; // 종가
              this._data[len][5] = pointData[5]; // 거래량
              this._data[len][7] = ''; // except 여부

              this.updatePointData(len, this._data[len], true);
              this._chart.redraw();
            }
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

        for (var i = this._exceptIdx + 1, len = this._dataLen, up_cnt = 1; i < len; i++, up_cnt++) {
          if (interval == 'MINUTE' || interval == 'HOURS') {
            var add_time = nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt);
            this._data[i][6] = add_time;
            this._data[i][0] = nexUtils.date2Utc(add_time);
          } else {
            var add_time = nexUtils.dateAdd(datePoint, interval, unit * up_cnt);
            this._data[i][6] = add_time;
            this._data[i][0] = nexUtils.date2Utc(add_time);
          }
        }

        for (var i = 0, len = this._seriesDataCnt; i < len; i++) {
          var data_type = this.getSeriesDataType(i);
          var series_id = this.getSeriesDataId(i);

          // 각 지표 Data 처리
          switch (data_type) {
            case 'candle':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id).update({
                data: this._seriesData[i].getData()
              });
              break;
            case 'volume':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id).update({
                data: this._seriesData[i].getData()
              });
              break;
            case 'sma':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id + '_1').update({
                data: this._seriesData[i].getData(1)
              });
              this._chart.get(series_id + '_2').update({
                data: this._seriesData[i].getData(2)
              });
              this._chart.get(series_id + '_3').update({
                data: this._seriesData[i].getData(3)
              });
              this._chart.get(series_id + '_4').update({
                data: this._seriesData[i].getData(4)
              });
              break;
            case 'cna':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id + '_1').update({
                data: this._seriesData[i].getData(1)
              });
              this._chart.get(series_id + '_2').update({
                data: this._seriesData[i].getData(2)
              });
              this._chart.get(series_id + '_3').update({
                data: this._seriesData[i].getData(3)
              });
              this._chart.get(series_id + '_4').update({
                data: this._seriesData[i].getData(4)
              });
              this._chart.get(series_id + '_5').update({
                data: this._seriesData[i].getData(5)
              });
              this._chart.get(series_id + '_6').update({
                data: this._seriesData[i].getData(6)
              });
              this._chart.get(series_id + '_7').update({
                data: this._seriesData[i].getData(7)
              });
              break;
            case 'bollinger':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id + '_1').update({
                data: this._seriesData[i].getData(1)
              });
              this._chart.get(series_id + '_2').update({
                data: this._seriesData[i].getData(2)
              });
              this._chart.get(series_id + '_3').update({
                data: this._seriesData[i].getData(3)
              });
              break;
            case 'envelope':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id + '_1').update({
                data: this._seriesData[i].getData(1)
              });
              this._chart.get(series_id + '_2').update({
                data: this._seriesData[i].getData(2)
              });
              this._chart.get(series_id + '_3').update({
                data: this._seriesData[i].getData(3)
              });
              break;
            case 'parabollic':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id).update({
                data: this._seriesData[i].getData()
              });
              break;
            case 'maribbon':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);

              for (var j = 0; j < this._seriesData[i].getRcnt(); j++) {
                this._chart.get(series_id + '_' + (j + 1)).update({
                  data: this._seriesData[i].getData(j)
                });
              }
              break;
            case 'macd':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id + '_1').update({
                data: this._seriesData[i].getData(1)
              });
              this._chart.get(series_id + '_2').update({
                data: this._seriesData[i].getData(2)
              });
              this._chart.get(series_id + '_3').update({
                data: this._seriesData[i].getData(3)
              });
              break;
            case 'slowstc':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id + '_1').update({
                data: this._seriesData[i].getData(2)
              });
              this._chart.get(series_id + '_2').update({
                data: this._seriesData[i].getData(3)
              });
              break;
            case 'cci':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id + '_1').update({
                data: this._seriesData[i].getData(3)
              });
              this._chart.get(series_id + '_2').update({
                data: this._seriesData[i].getData(4)
              });
              break;
            case 'mental':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id + '_1').update({
                data: this._seriesData[i].getData(1)
              });
              this._chart.get(series_id + '_2').update({
                data: this._seriesData[i].getData(2)
              });
              break;
            case 'adx':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id + '_1').update({
                data: this._seriesData[i].getData(1)
              });
              this._chart.get(series_id + '_2').update({
                data: this._seriesData[i].getData(2)
              });
              this._chart.get(series_id + '_3').update({
                data: this._seriesData[i].getData(3)
              });
              break;
            case 'obv':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id + '_1').update({
                data: this._seriesData[i].getData(1)
              });
              this._chart.get(series_id + '_2').update({
                data: this._seriesData[i].getData(2)
              });
              break;
            case 'sonar':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id + '_1').update({
                data: this._seriesData[i].getData(1)
              });
              this._chart.get(series_id + '_2').update({
                data: this._seriesData[i].getData(2)
              });
              break;
            case 'vr':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id).update({
                data: this._seriesData[i].getData()
              });
              break;
            case 'trix':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id + '_1').update({
                data: this._seriesData[i].getData(1)
              });
              this._chart.get(series_id + '_2').update({
                data: this._seriesData[i].getData(2)
              });
              break;
            case 'williams':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id).update({
                data: this._seriesData[i].getData()
              });
              break;
            case 'roc':
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id + '_1').update({
                data: this._seriesData[i].getData(1)
              });
              this._chart.get(series_id + '_2').update({
                data: this._seriesData[i].getData(2)
              });
              break;
            default: // 캔들
              this._seriesData[i].datePointChangeData(datePoint, interval, unit);
              this._chart.get(series_id).update({
                data: this._seriesData[i].getData()
              });
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
              this._seriesData[i].addPointData(pointData);
              this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getLastData(1, false).slice(), false, false, false);
              this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getLastData(2, false).slice(), false, false, false);
              this._chart.get(series_id + '_3').addPoint(this._seriesData[i].getLastData(3, false).slice(), false, false, false);
              this._chart.get(series_id + '_4').addPoint(this._seriesData[i].getLastData(4, false).slice(), false, false, false);
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
            case 'parabollic':
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
              this._chart.get(series_id + '_1').addPoint(this._seriesData[i].getLastData(1, false), false, false, false);
              this._chart.get(series_id + '_2').addPoint(this._seriesData[i].getLastData(2, false), false, false, false);
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
              this._chart.get(series_id).addPoint(this._seriesData[i].getLastData(false).slice(), false, false, false);
              break;
            case 'roc':
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
              this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);
              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx() - 1;
              this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(1).slice(), false, false, false);
              this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(2).slice(), false, false, false);
              this._chart.get(series_id + '_3').data[upd_idx].update(this._seriesData[i].getLastData(3).slice(), false, false, false);
              this._chart.get(series_id + '_4').data[upd_idx].update(this._seriesData[i].getLastData(4).slice(), false, false, false);
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
            case 'parabollic':
              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx() - 1;
              this._seriesData[i].updatePointData(upd_idx, pointData);
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
              this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(1).slice(), false, false, false);
              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(2) - 1;
              this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(2).slice(), false, false, false);
              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(3) - 1;
              this._chart.get(series_id + '_3').data[upd_idx].update(this._seriesData[i].getLastData(3).slice(), false, false, false);
              break;
            case 'slowstc': // (완료)
              this._seriesData[i].updatePointData(upd_idx, this._data, exceptFlag);
              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(2) - 1;
              this._chart.get(series_id + '_1').data[upd_idx].update(this._seriesData[i].getLastData(2).slice(), false, false, false);
              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx(3) - 1;
              this._chart.get(series_id + '_2').data[upd_idx].update(this._seriesData[i].getLastData(3).slice(), false, false, false);
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
              if (exceptFlag) upd_idx = this._seriesData[i].getExceptIdx() - 1;
              this._chart.get(series_id).data[upd_idx].update(this._seriesData[i].getLastData().slice(), false, false, false);
              break;
            case 'roc': // (완료)
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
          this._data[i][0] = nexUtils.date2Utc(nexUtils.dateAdd(datePoint, interval, unit * up_cnt));
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
        var data_close 	= chartData[i][4]
        var data_volume = chartData[i][5];
        
        var volume_color = this._chart.getLineColor('volume');
        if (Number(data_open) > Number(data_close)) {
          volume_color = this._chart.getLineColor('volume1');
        } else if (Number(data_open) == Number(data_close)) {
          volume_color = "#000000";
        }

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
          this._data[i]['x'] = nexUtils.date2Utc(nexUtils.dateAdd(datePoint, interval, unit * up_cnt));
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
        var volume_color = this._chart.getLineColor('volume');

        if (Number(pointData[1]) > Number(pointData[4])) {
          volume_color = this._chart.getLineColor('volume1');
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
        var volume_color = this._chart.getLineColor('volume');

        if (Number(pointData[1]) > Number(pointData[4])) {
          volume_color = this._chart.getLineColor('volume1');
        } else if (Number(pointData[1]) == Number(pointData[4])) {
          volume_color = "#000000";
        }

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
        data[this._exceptIdx[i + 1]][0] = nexUtils.date2Utc(datePoint);

        for (var j = this._exceptIdx[i + 1] + 1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {
          if (interval == 'MINUTE' || interval == 'HOURS') {
            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));
          } else {
            data[j][0] = nexUtils.date2Utc(nexUtils.dateAdd(datePoint, interval, unit * up_cnt));
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
            if (i >= this._dataCnaNums[0] - 1) {
              var dates_high_price1 = nexChartUtils.getHighMax(i, this._dataCnaNums[0], chartData);
              var dates_low_price1 = nexChartUtils.getLowMin(i, this._dataCnaNums[0], chartData);

              this.arr_dataSum1[i] = [(dates_high_price1 + dates_low_price1) / 2, chartData[i][0]];

              this._data1.push([Number(chartData[i][0]), Number(this.arr_dataSum1[i][0])]);
              this._exceptIdx[0]++;
            } else {
              this.arr_dataSum1[i] = [null, chartData[i][0]];
            }
            // 전환선(9) = (최근 9일간의 최고치 + 최저치) / 2 (i >= 8 일때 부터)
            if (i >= this._dataCnaNums[1] - 1) {
              var dates_high_price2 = nexChartUtils.getHighMax(i, this._dataCnaNums[1], chartData);
              var dates_low_price2 = nexChartUtils.getLowMin(i, this._dataCnaNums[1], chartData);

              this.arr_dataSum2[i] = [(dates_high_price2 + dates_low_price2) / 2, chartData[i][0]];

              this._data2.push([Number(chartData[i][0]), Number(this.arr_dataSum2[i][0])]);
              this._exceptIdx[1]++;
            } else {
              this.arr_dataSum2[i] = [null, chartData[i][0]];
            }
            // 후행스팬(26) 그날의 종가를 26일 후행시킨선
            if (i <= chartData.length - this._dataCnaNums[2]) {
              var data_sum3 = chartData[i + (this._dataCnaNums[2] - 1)][4];

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
          if (i >= (this._dataCnaNums[0] + this._dataCnaNums[3] - 2)) {
            data_sum4 = (this.arr_dataSum1[i - this._dataCnaNums[3] + 1][0] + this.arr_dataSum2[i - this._dataCnaNums[3] + 1][0]) / 2;

            this._data4.push([Number(chartData[i][0]), Number(data_sum4)]);
            this._exceptIdx[3]++;
            //console.log(chartData[i][6] + "//i=" + i + "//data_sum4=" + data_sum4);
          }
          
          // 장기선행스팬(52) = (최근 52일간의 최고치 + 최저치) / 2 를 26일 선행(앞으로)시킨선 (i >= 76일때 부터)
          var data_sum5 = null;
          if (i >= (this._dataCnaNums[4] - 1)) { // (i >= 51일때 부터)
            var dates_high_price3 = nexChartUtils.getHighMax(i, this._dataCnaNums[4], chartData); // 52일 최고
            var dates_low_price3 = nexChartUtils.getLowMin(i, this._dataCnaNums[4], chartData); // 52일 최저

            this.arr_datesHightPrice3[i] = [dates_high_price3, chartData[i][0]];
            this.arr_datesLowPrice3[i] = [dates_low_price3, chartData[i][0]];

            if (i >= this._dataCnaNums[4] + this._dataCnaNums[3] - 2) { // (i >= 76일때부터)
              data_sum5 = (this.arr_datesHightPrice3[i - this._dataCnaNums[3] + 1][0] + this.arr_datesLowPrice3[i - this._dataCnaNums[3] + 1][0]) / 2;

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
            data[j][0] = nexUtils.date2Utc(nexUtils.dateAdd(datePoint, interval, unit * up_cnt));
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
        if (point >= this._dataCnaNums[0] - 1) {
          var dates_high_price1 = nexChartUtils.getHighMax(point, this._dataCnaNums[0], chartData);
          var dates_low_price1 = nexChartUtils.getLowMin(point, this._dataCnaNums[0], chartData);

          this.arr_dataSum1[point] = [(dates_high_price1 + dates_low_price1) / 2, chartData[point][0]];

          this._data1.push([Number(date_utc_time), null]);
          this._exceptIdx[0]++;
        } else {
          this.arr_dataSum1[point] = [null, chartData[point][0]];
        }

        // 전환선(9) = (최근 9일간의 최고치 + 최저치) / 2 (i >= 8 일때 부터)
        if (point >= this._dataCnaNums[1] - 1) {
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
        if (point >= (this._dataCnaNums[0] + this._dataCnaNums[3] - 2)) { //
          data_sum4 = (this.arr_dataSum1[point - this._dataCnaNums[3] + 1][0] + this.arr_dataSum2[point - this._dataCnaNums[3] + 1][0]) / 2;

          this._data4.push([Number(date_utc_time), null]);
        }
        this._exceptIdx[3]++;

        var data_sum5 = null;
        // 장기선행스팬(52) = (최근 52일간의 최고치 + 최저치) / 2 를 26일 선행(앞으로)시킨선 (i >= 76일때 부터)
        if (point >= (this._dataCnaNums[4] - 1)) { // (i >= 51일때 부터)
          var dates_high_price3 = nexChartUtils.getHighMax(point, this._dataCnaNums[4], chartData); // 52일 최고
          var dates_low_price3 = nexChartUtils.getLowMin(point, this._dataCnaNums[4], chartData); // 52일 최저

          this.arr_datesHightPrice3[point] = [dates_high_price3, chartData[point][0]];
          this.arr_datesLowPrice3[point] = [dates_low_price3, chartData[point][0]];

          if (point >= this._dataCnaNums[4] + this._dataCnaNums[3] - 2) { // (i >= 76일때부터)
            data_sum5 = (this.arr_datesHightPrice3[point - this._dataCnaNums[3] + 1][0] + this.arr_datesLowPrice3[point - this._dataCnaNums[3] + 1][0]) / 2;

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
        if (point >= this._dataCnaNums[0] - 1) {
          var dates_high_price1 = nexChartUtils.getHighMax(point, this._dataCnaNums[0], chartData);
          var dates_low_price1 = nexChartUtils.getLowMin(point, this._dataCnaNums[0], chartData);

          this.arr_dataSum1[point] = [(dates_high_price1 + dates_low_price1) / 2, chartData[point][0]];

          this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), Number(this.arr_dataSum1[point][0])];
        } else {
          this.arr_dataSum1[point] = [null, chartData[point][0]];
        }

        // 전환선(9) = (최근 9일간의 최고치 + 최저치) / 2 (i >= 8 일때 부터)
        if (point >= this._dataCnaNums[1] - 1) {
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
        if (point >= (this._dataCnaNums[0] + this._dataCnaNums[3] - 2)) { //
          data_sum4 = (this.arr_dataSum1[point][0] + this.arr_dataSum2[point][0]) / 2;

          this._data4[exceptFlag ? (this._exceptIdx[3] - 1) : point] = [Number(this._data4[exceptFlag ? (this._exceptIdx[3] - 1) : point][0]), Number(data_sum4)];
        }

        var data_sum5 = null;
        // 장기선행스팬(52) = (최근 52일간의 최고치 + 최저치) / 2 를 26일 선행(앞으로)시킨선 (i >= 76일때 부터)
        if (point >= (this._dataCnaNums[4] - 1)) { // (i >= 51일때 부터)
          var dates_high_price3 = nexChartUtils.getHighMax(point, this._dataCnaNums[4], chartData); // 52일 최고
          var dates_low_price3 = nexChartUtils.getLowMin(point, this._dataCnaNums[4], chartData); // 52일 최저

          this.arr_datesHightPrice3[point] = [dates_high_price3, chartData[point][0]];
          this.arr_datesLowPrice3[point] = [dates_low_price3, chartData[point][0]];

          if (point >= this._dataCnaNums[4] + this._dataCnaNums[3] - 2) { // (i >= 76일때부터)
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
   * desc : 볼린저 데이터 객체(bollinger)
   * date : 2015.07.22
   * 
   */
  var bollingerData = function(chart, seqId, chartData, smaNum) {
	 this._chart = chart;
	 this._type = 'bollinger';
    this._id = seqId;
    this._data1 = []; //상한선
    this._data2 = []; //중심선
    this._data3 = []; //하한선

    this._dataSmaNum = smaNum; //중심선 이동평균일
    this._stdDev = 2; //Standard Deviations

    this._exceptIdx = 0;

    this.arr_m_baseAvg = [];
    this.arr_baseAvg = [];

    this.init();
    this.setData(chartData);
  }
  bollingerData.prototype = {
    init: function() {
      this._exceptIdx = 0;

      this.arr_m_baseAvg = [];
      this.arr_baseAvg = [];
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
     * 중심선 이동평균일 리턴.
     * @return
     */
    getSmaNum: function() {
      return this._dataSmaNum;
    },
    /**
     * desc : 초기 전체 데이터 가공
     * date : 2015.07.22
     * 
     *
     * Bollinger Bands 계산식
     * 평균주가 : 고가+저가+종가 / 3
     * 중간밴드 : 평균주가 n일 단순이동평균
     * 상한밴드 : up_band = avg + (stdDev * sdv)
     * 하한밴드 : down_band = avg - (stdDev * sdv)
     * 기본설정값 : 20일
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
            var base_avg = Number((chartData[i][2] + chartData[i][3] + chartData[i][4]) / 3);

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
        data[this._exceptIdx[i + 1]][0] = nexUtils.date2Utc(datePoint);

        for (var j = this._exceptIdx[i + 1] + 1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {
          if (interval == 'MINUTE' || interval == 'HOURS') {
            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));
          } else {
            data[j][0] = nexUtils.date2Utc(nexUtils.dateAdd(datePoint, interval, unit * up_cnt));
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
        var base_avg = Number((chartData[point][2] + chartData[point][3] + chartData[point][4]) / 3);

        this.arr_baseAvg[point] = base_avg;

        if (point >= this._dataSmaNum - 1) {
          m_base_avg = this.arr_m_baseAvg[point - 2] + base_avg;
          this.arr_m_baseAvg[point - 1] = m_base_avg;
          if (point == this._dataSmaNum - 1) { // 중간밴드 (이동 평균값) : i 가 this._day 와 같을때 이동평균
            avg = m_b_aseAvg / this._dataSmaNum;
          } else { // 중간밴드 (이동 평균값) : i 가 this._day 보다 클때 이동평균
            avg = (m_bas_aAvg - this.arr_m_baseAvg[point - this._dataSmaNum - 1]) / this._dataSmaNum;
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
        data[this._exceptIdx[i + 1]][0] = nexUtils.date2Utc(datePoint);

        for (var j = this._exceptIdx[i + 1] + 1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {
          if (interval == 'MINUTE' || interval == 'HOURS') {
            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));
          } else {
            data[j][0] = nexUtils.date2Utc(nexUtils.dateAdd(datePoint, interval, unit * up_cnt));
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
            this._data[i][j][0] = nexUtils.date2Utc(nexUtils.dateAdd(datePoint, interval, unit * up_cnt));
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
                this.arr_ema1[i] = chartData[i][4] * factor1 + (1 - factor1) * this.arr_ema1[i - 1];
                this.arr_ema2[i] = chartData[i][4] * factor2 + (1 - factor2) * this.arr_ema2[i - 1];
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
                this.arr_signal[i] = macd * factor3 + (1 - factor3) * this.arr_signal[i - 1];
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
                color = this._chart.getLineColor('volume');
              } else {
                color = this._chart.getLineColor('volume1');
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
            data[j][0] = nexUtils.date2Utc(nexUtils.dateAdd(datePoint, interval, unit * up_cnt));
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
            this.arr_ema1[point] = chartData[point][4] * factor1 + (1 - factor1) * this.arr_ema1[point - 1];
            this.arr_ema2[point] = chartData[point][4] * factor2 + (1 - factor2) * this.arr_ema2[point - 1];
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
            this.arr_signal[point] = macd * factor3 + (1 - factor3) * this.arr_signal[point - 1];
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
            color = this._chart.getLineColor('volume');
          } else {
            color = this._chart.getLineColor('volume1');
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
            var toate_close_price = chartData[i][4],
              dates_high_price = 0,
              dates_Low_price = 0,
              StcK = 0;

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
              this.arr_slowK[i] = (StcK * (2 / (this._slowK + 1))) + this.arr_slowK[i - 1] * (1 - (2 / (this._slowK + 1)));
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
              this.arr_slowD[i] = (this.arr_slowK[i] * (2 / (this._slowD + 1))) + this.arr_slowD[i - 1] * (1 - (2 / (this._slowD + 1)));
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
          // console.log(i + "//" + chartData[i][6] + "//" + dates_high_price + "//" + dates_Low_price + "//" + StcK + "//" + slowK + "//" + slowD);
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
            data[j][0] = nexUtils.date2Utc(nexUtils.dateAdd(datePoint, interval, unit * up_cnt));
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
          this.arr_slowK[point] = (StcK * (2 / (this._slowK + 1))) + this.arr_slowK[point - 1] * (1 - (2 / (this._slowK + 1)));
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
          this.arr_slowD[point] = (this.arr_slowK[point] * (2 / (this._slowD + 1))) + this.arr_slowD[point - 1] * (1 - (2 / (this._slowD + 1)));
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
   * desc : cci slow 데이터 객체(cci)
   * date : 2015.07.22
   * 
   */
  var cciData = function(chart, seqId, chartData, day) {
	 this._chart = chart;
	 this._type = 'cci';
    this._id = seqId;
    this._data1 = []; // cci 평균가격
    this._data2 = []; // cci 이동평균가격
    this._data3 = []; // cci
    this._data4 = []; // cci 시그널선
    this._day = day; // 기간

    this._exceptIdx = [];

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

            this._data3.push([Number(chartData[i][0]), cci_val]);
            this._exceptIdx[2]++;

            // 시그널선 계산 (시그널 기간설정값 signal_day = 9일 고정)
            var signal_day = 9;
            if (i == this._day - 1) { // i가 13 일때, 초기값은 cci_val 값을 그대로 사용
              this.arr_signal[i] = cci_val;
            } else { // i가 10 보다 클때
              this.arr_signal[i] = (cci_val * (2 / (signal_day + 1))) + this.arr_signal[i - 1] * (1 - (2 / (signal_day + 1)));
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
            data[j][0] = nexUtils.date2Utc(nexUtils.dateAdd(datePoint, interval, unit * up_cnt));
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

        this._data3[exceptFlag ? (this._exceptIdx[2] - 1) : point] = [Number(date_utc_time), cci_val];

        // 시그널선 계산 (시그널 기간설정값 signal_day = 9일 고정)
        var signal_day = 9;
        if (point == this._day - 1) { // i가 13 일때, 초기값은 cci_val 값을 그대로 사용
          this.arr_signal[point] = cci_val;
        } else { // i가 10 보다 클때
          this.arr_signal[point] = (cci_val * (2 / (signal_day + 1))) + this.arr_signal[point - 1] * (1 - (2 / (signal_day + 1)));
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
   * 
   */
  var mentalData = function(chart, seqId, chartData, day) {
	 this._chart = chart;
	 this._type = 'mental';
    this._id = seqId;
    this._data1 = []; //심리도선(mental)
    this._data2 = []; //시그널선
    this._day = day; // 기간

    this._exceptIdx = [];

    this.arr_signal = [];

    this.init();
    this.setData(chartData);
  }
  mentalData.prototype = {
    init: function() {
      this._exceptIdx[0] = 0;
      this._exceptIdx[1] = 0;

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

              this._data1.push([Number(chartData[i][0]), mental]);
              this._exceptIdx[0]++;

              // 시그널선 계산 (시그널 기간설정값 signal_day = 15 고정)
              var signal_day = 15;
              if (i == this._day) { // i가 10 일때, 초기값은 mental 값을 그대로 사용
                this.arr_signal[i] = mental;
              } else { // i가 10 보다 클때
                this.arr_signal[i] = (mental * (2 / (signal_day + 1))) + this.arr_signal[i - 1] * (1 - (2 / (signal_day + 1)));
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
      var data_arr = [this._data1, this._data2];
      for (var i = 0; i < 2; i++) {
        var data = data_arr[i];
        data[this._exceptIdx[i]][0] = nexUtils.date2Utc(datePoint);

        for (var j = this._exceptIdx[i] + 1, len = data.length, up_cnt = 1; j < len; j++, up_cnt++) {
          if (interval == 'MINUTE' || interval == 'HOURS') {
            data[j][0] = nexUtils.date2Utc(nexChartUtils.getAddTime(interval, datePoint, unit * up_cnt));
          } else {
            data[j][0] = nexUtils.date2Utc(nexUtils.dateAdd(datePoint, interval, unit * up_cnt));
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

        var date_utc_time = chartData[point][0],
          upDate = 0;

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
          this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), mental];

          // 시그널선 계산 (시그널 기간설정값 signal_day = 15 고정)
          var signal_day = 15; // 설정 값 되도록 처리(필요)
          if (point == this._day) { // i가 10 일때, 초기값은 mental 값을 그대로 사용
            this.arr_signal[point] = mental;
          } else { // i가 10 보다 클때
            this.arr_signal[point] = (mental * (2 / (signal_day + 1))) + this.arr_signal[point - 1] * (1 - (2 / (signal_day + 1)));
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
        var K = 2 / (this._day + 1);
        for (var i = 1, len = chartData.length; i < len; i++) {
          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {

            var temp_pdm1 = Number(chartData[i][2]) - Number(chartData[i - 1][2]), // 당일고가 - 전일고가
              temp_pdm2 = Number(chartData[i - 1][3]) - Number(chartData[i][3]); // 전일저가 - 당일저가

            var pdm = 0;
            if (temp_pdm1 > 0 && temp_pdm1 > temp_pdm2) {
              pdm = temp_pdm1;
            }

            var mdm = 0;
            if (temp_pdm2 > 0 && temp_pdm1 < temp_pdm2) {
              mdm = temp_pdm2;
            }

            var temp_pdi1 = (Number(chartData[i][2]) - Number(chartData[i][3])), // 당일고가 - 당일저가
              temp_pdi2 = Math.abs(Number(chartData[i - 1][4]) - Number(chartData[i][2])), // 전일종가 - 당일고가
              temp_pdi3 = Math.abs(Number(chartData[i - 1][4]) - Number(chartData[i][3])), // 전일종가 - 당일저가
              tr = Math.max(temp_pdi1, temp_pdi2, temp_pdi3); // TR

            if (i == 1) {
              this.arr_ema_pdi[i] = Number(pdm * K); // pdm n일 지수이동평균
              this.arr_ema_mdi[i] = Number(mdm * K); // mdm n일 지수이동평균
              this.arr_ema_tr[i] = Number(tr * K); // tr n일 지수이동평균
            } else {
              this.arr_ema_pdi[i] = Number(pdm * K + this.arr_ema_pdi[i - 1] * (1 - K)); // pdm n일 지수이동평균
              this.arr_ema_mdi[i] = Number(mdm * K + this.arr_ema_mdi[i - 1] * (1 - K)); // mdm n일 지수이동평균
              this.arr_ema_tr[i] = Number(tr * K + this.arr_ema_tr[i - 1] * (1 - K)); // tr n일 지수이동평균
            }

            // PDI, MDI 계산
            var pdi = Number(this.arr_ema_pdi[i]) / Number(this.arr_ema_tr[i]) * 100,
              mdi = Number(this.arr_ema_mdi[i]) / Number(this.arr_ema_tr[i]) * 100,
              temp_pdi4 = Math.abs(pdi - mdi),
              temp_mdi4 = pdi + mdi,
              dx = (temp_pdi4 / temp_mdi4) * 100;

            if (i >= this._day - 1) {
              this._data1.push([Number(chartData[i][0]), Number(pdi.toFixed(2))]);
              this._exceptIdx[0]++;
              this._data2.push([Number(chartData[i][0]), Number(mdi.toFixed(2))]);
              this._exceptIdx[1]++;
            }

            // ADX 계산
            if (i >= this._day) {
              if (i == this._day) {
                this.arr_Adx[i] = Number(dx * K); // dx n일 지수이동평균 (전일값 =0)
              } else {
                this.arr_Adx[i] = Number(dx * K + this.arr_Adx[i - 1] * (1 - K)); // dx n일 지수이동평균
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
            data[j][0] = nexUtils.date2Utc(nexUtils.dateAdd(datePoint, interval, unit * up_cnt));
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

        var K = 2 / (this._day + 1),
          date_utc_time = chartData[point][0],
          temp_pdm1 = Number(chartData[point][2]) - Number(chartData[point - 1][2]), // 당일고가 - 전일고가
          temp_pdm2 = Number(chartData[point - 1][3]) - Number(chartData[point][3]); // 전일저가 - 당일저가

        var pdm = 0;
        if (temp_pdm1 > 0 && temp_pdm1 > temp_pdm2) {
          pdm = temp_pdm1;
        }

        var mdm = 0;
        if (temp_pdm2 > 0 && temp_pdm1 < temp_pdm2) {
          mdm = temp_pdm2;
        }

        var temp_pdi1 = (Number(chartData[point][2]) - Number(chartData[point][3])), // 당일고가 - 당일저가
          temp_pdi2 = Math.abs(Number(chartData[point - 1][4]) - Number(chartData[point][2])), // 전일종가 - 당일고가
          temp_pdi3 = Math.abs(Number(chartData[point - 1][4]) - Number(chartData[point][3])); // 전일종가 - 당일저가

        var tr = Math.max(temp_pdi1, temp_pdi2, temp_pdi3); // TR
        if (point == 1) {
          this.arr_ema_pdi[point] = Number(pdm * K); // pdm n일 지수이동평균
          this.arr_ema_mdi[point] = Number(mdm * K); // mdm n일 지수이동평균
          this.arr_ema_tr[point] = Number(tr * K); // tr n일 지수이동평균
        } else {
          this.arr_ema_pdi[point] = Number(pdm * K + this.arr_ema_pdi[point - 1] * (1 - K)); // pdm n일 지수이동평균
          this.arr_ema_mdi[point] = Number(mdm * K + this.arr_ema_mdi[point - 1] * (1 - K)); // mdm n일 지수이동평균
          this.arr_ema_tr[point] = Number(tr * K + this.arr_ema_tr[point - 1] * (1 - K)); // tr n일 지수이동평균
        }

        // PDI, MDI 계산
        var pdi = Number(this.arr_ema_pdi[i]) / Number(this.arr_ema_tr[i]) * 100,
          mdi = Number(this.arr_ema_mdi[i]) / Number(this.arr_ema_tr[i]) * 100,
          temp_pdi4 = Math.abs(pdi - mdi),
          temp_mdi4 = pdi + mdi;

        var dx = (temp_pdi4 / temp_mdi4) * 100;
        if (point >= this._day - 1) {
          this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), Number(pdi.toFixed(2))];
          this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point] = [Number(date_utc_time), Number(mdi.toFixed(2))];
        }

        // ADX 계산
        if (point >= this._day) {
          if (point == this._day) {
            this.arr_Adx[point] = Number(dx * K); // dx n일 지수이동평균 (전일값 = 0)
          } else {
            this.arr_Adx[point] = Number(dx * K + this.arr_Adx[point - 1] * (1 - K)); // dx n일  지수이동평균
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
        for (var i = 1, len = chartData.length; i < len; i++) {
          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {
            // obv 구하기
            var obvVal = 0;
            this.arr_preobv[i] = this.arr_preobv[i - 1];

            if (Number(chartData[i][4]) > Number(chartData[i - 1][4])) {
              if (i == 1) {
                obvVal = chartData[i][5];
                this.arr_preobv[i] = obvVal;
              } else {
                obvVal = this.arr_preobv[i - 1] + chartData[i][5];
                this.arr_preobv[i] = obvVal;
              }
            } else if (Number(chartData[i][4]) < Number(chartData[i - 1][4])) {
              if (i == 1) {
                obvVal = 0 - chartData[i][5];
                this.arr_preobv[i] = obvVal;
              } else {
                obvVal = this.arr_preobv[i - 1] - chartData[i][5];
                this.arr_preobv[i] = obvVal;
              }
            } else if (chartData[i][4] == chartData[i - 1][4]) {
              obvVal = this.arr_preobv[i - 1];
            } else {
              obvVal = null;
            }

            this._data1.push([Number(chartData[i][0]), obvVal]);
            this._exceptIdx[0]++;

            //시그널선 구하기 (시그널 기간설정값 this._day)
            if (i == 1) { // i가 1 일때, 초기값은 obvVal 값을 그대로 사용
              this.arr_signal[i] = obvVal;
            } else { // i가 1 보다 클때
              this.arr_signal[i] = (obvVal * (2 / (this._day + 1))) + this.arr_signal[i - 1] * (1 - (2 / (this._day + 1)));
            }

            if (i >= 1 + this._day - 1) { // i가 9 또는 9 보다 클때
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
            data[j][0] = nexUtils.date2Utc(nexUtils.dateAdd(datePoint, interval, unit * up_cnt));
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
        if (chartData[point][4] > chartData[point - 1][4]) {
          if (point == 1) {
            obvVal = chartData[point][5];
            this.arr_preobv[point] = obvVal;
          } else {
            obvVal = this.arr_preobv[point - 1] + chartData[point][5];
            this.arr_preobv[point] = obvVal;
          }
        } else if (chartData[point][4] < chartData[point - 1][4]) {
          if (point == 1) {
            obvVal = 0 - chartData[point][5];
            this.arr_preobv[point] = obvVal;
          } else {
            obvVal = this.arr_preobv[point - 1] - chartData[point][5];
            this.arr_preobv[point] = obvVal;
          }
        } else if (chartData[point][4] == chartData[point - 1][4]) {
          obvVal = this.arr_preobv[point - 1];
        } else {
          obvVal = null;
        }

        this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), obvVal];

        //시그널선 구하기 (시그널 기간설정값 this._day)
        if (point == 1) { // i가 1 일때, 초기값은 obvVal 값을 그대로 사용
          this.arr_signal[point] = obvVal;
        } else { // i가 1 보다 클때
          this.arr_signal[point] = (obvVal * (2 / (this._day + 1))) + this.arr_signal[point - 1] * (1 - (2 / (this._day + 1)));
        }

        if (point >= 1 + this._day - 1) { // i가 9 또는 9 보다 클때
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

    this.arr_ema = [];
    this.arr_signal = [];

    this.init();
    this.setData(chartData);
  }
  sonarData.prototype = {
    init: function() {
      this._exceptIdx[0] = 0;
      this._exceptIdx[1] = 0;

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
     * SONAR = 당일지수이동평균 - n일전 지수이동평균
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
              this.arr_ema[i] = (chartData[i][4] * (2 / (this._emaNum1 + 1))) + this.arr_ema[i - 1] * (1 - (2 / (this._emaNum1 + 1)));

              var sonarVal = this.arr_ema[i] - this.arr_ema[i - this._day];

              this._data1.push([Number(chartData[i][0]), Number(sonarVal.toFixed(2))]);
              this._exceptIdx[0]++;

              // 시그널선 계산
              if (i == this._emaNum1 + this._day - 1) { // i가 28일때, 초기값은 sonar 값을 그대로 사용
                this.arr_signal[i] = sonarVal;
              } else { // i가 28보다 클때
                this.arr_signal[i] = (sonarVal * (2 / (this._signal + 1))) + this.arr_signal[i - 1] * (1 - (2 / (this._signal + 1)));
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
                this.arr_ema[i] = (chartData[i][4] * (2 / (this._emaNum1 + 1))) + this.arr_ema[i - 1] * (1 - (2 / (this._emaNum1 + 1)));
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
            data[j][0] = nexUtils.date2Utc(nexUtils.dateAdd(datePoint, interval, unit * up_cnt));
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
          this.arr_ema[point] = (chartData[point][4] * (2 / (this._emaNum1 + 1))) + this.arr_ema[point - 1] * (1 - (2 / (this._emaNum1 + 1)));

          var sonarVal = this.arr_ema[point] - this.arr_ema[point - this._day];
          this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), Number(sonarVal.toFixed(2))];

          // 시그널선 계산
          if (point == this._emaNum1 + this._day - 1) { // i가 28일때, 초기값은 sonar 값을 그대로 사용
            this.arr_signal[point] = sonarVal;
          } else { // i가 28보다 클때
            this.arr_signal[point] = (sonarVal * (2 / (this._signal + 1))) + this.arr_signal[point - 1] * (1 - (2 / (this._signal + 1)));
          }

          if (point >= this._emaNum1 + this._day + this._signal - 2) { // i가 36 또는 36 보다 클때
            var signal_val = this.arr_signal[point];
            this._data2[exceptFlag ? (this._exceptIdx[1] - 1) : point] = [Number(date_utc_time), Number(signal_val.toFixed(2))];
          }
        } else {
          if (point == 0) {
            this.arr_ema[point] = chartData[point][4];
          } else {
            this.arr_ema[point] = (chartData[point][4] * (2 / (this._emaNum1 + 1))) + this.arr_ema[point - 1] * (1 - (2 / (this._emaNum1 + 1)));
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

      var last_data = {},
        last_len = 0;

      if (dataNum == 1) {
        last_len = this._data1.length;

        // 빈데이터(현재일 + 26일) 있을 경우 마지막 날짜로 현재일 세팅
        if (exceptFlag && this._exceptIdx[0] != 0) {
          last_len = this._exceptIdx[0] - 1;
        }

        last_data = this._data1[last_len];
      } else if (dataNum == 2) {
        last_len = this._data2.length;

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
          this._data[i][0] = nexUtils.date2Utc(nexUtils.dateAdd(datePoint, interval, unit * up_cnt));
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
              this.arr_ema1[i] = (chartData[i][4] * (2 / (this._day + 1))) + this.arr_ema1[i - 1] * (1 - (2 / (this._day + 1)));
              this.arr_ema2[i] = (this.arr_ema1[i] * (2 / (this._day + 1))) + this.arr_ema2[i - 1] * (1 - (2 / (this._day + 1)));
            }

            if (i < this._day * 2 - 2) { // i가 22보다 작을때
              this.arr_ema3[i] = 0;
            } else {
              this.arr_ema3[i] = (this.arr_ema2[i] * (2 / (this._day + 1))) + this.arr_ema3[i - 1] * (1 - (2 / (this._day + 1)));
            }

            if (i >= this._day * 3 - 2) { // i가 34보다 작을때
              trixVal = ((this.arr_ema3[i] - this.arr_ema3[i - 1]) / this.arr_ema3[i - 1]) * 100;

              this._data1.push([Number(chartData[i][0]), Number(trixVal.toFixed(2))]);
              this._exceptIdx[0]++;
            }

            //시그널선 계산하기
            if (i == this._day * 3 - 2) { // i가 34일때 초기값은 trix 값을 그대로 사용
              this.arr_signal[i] = trixVal;
            } else { // i가 34보다 클때
              this.arr_signal[i] = (trixVal * (2 / (this._signal + 1))) + this.arr_signal[i - 1] * (1 - (2 / (this._signal + 1)));
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
            data[j][0] = nexUtils.date2Utc(nexUtils.dateAdd(datePoint, interval, unit * up_cnt));
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
          this.arr_ema1[point] = (chartData[point][4] * (2 / (this._day + 1))) + this.arr_ema1[point - 1] * (1 - (2 / (this._day + 1)));
          this.arr_ema2[point] = (this.arr_ema1[point] * (2 / (this._day + 1))) + this.arr_ema2[point - 1] * (1 - (2 / (this._day + 1)));
        }

        if (point < this._day * 2 - 2) { // i가 22보다 작을때
          this.arr_ema3[point] = 0;
        } else {
          this.arr_ema3[point] = (this.arr_ema2[point] * (2 / (this._day + 1))) + this.arr_ema3[point - 1] * (1 - (2 / (this._day + 1)));
        }

        if (point >= this._day * 3 - 2) { // i가 34보다 작을때
          trixVal = ((this.arr_ema3[point] - this.arr_ema3[point - 1]) / this.arr_ema3[point - 1]) * 100;
          this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), Number(trixVal.toFixed(2))];
        }

        //시그널선 계산하기
        if (point == this._day * 3 - 2) { // i가 34일때 초기값은 trix 값을 그대로 사용
          this.arr_signal[point] = trixVal;
        } else { // i가 34보다 클때
          this.arr_signal[point] = (trixVal * (2 / (this._signal + 1))) + this.arr_signal[point - 1] * (1 - (2 / (this._signal + 1)));
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
   * date : 2015.07.22
   * 
   */
  var williamsData = function(chart, seqId, chartData, day) {
	 this._chart = chart;
	 this._type = 'williams';
    this._id = seqId;
    this._data = []; //williams
    this._day = day; //기간

    this._exceptIdx = 0;

    this.init();
    this.setData(chartData);
  }
  williamsData.prototype = {
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
     * williams'%R 계산식
     * williams'%R = [당일종가-(최근n일중 최고가)/(최근n일중 최고가-최근n일중 최저가)] * 100
     * @param chartData : 차트 데이터
     */
    setData: function(chartData) {
      if (chartData != null && chartData.length > 0) {
        // williams 구하기
        for (var i = 0, len = chartData.length; i < len; i++) {
          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {
            var williams = 0;
            if (i - this._day >= 0) {
              var toate_close_price = chartData[i][4], // 당일종가
                dates_high_price = nexChartUtils.getHighMax(i, this._day, chartData), //최근 n일 최고가
                dates_Low_price = nexChartUtils.getLowMin(i, this._day, chartData); //최근 n일 최저가

              williams = Number((toate_close_price - dates_high_price) / (dates_high_price - dates_Low_price) * 100);
              this._data.push([Number(chartData[i][0]), Number((Math.round(williams * 100)) / 100)]);
              this._exceptIdx++;
            }
          } else if (chartData[i][6] != 'undefined' && chartData[i][6] != null && chartData[i][6] == 'except') {
            this._data.push([Number(chartData[i][0]), null]);
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
          this._data[i][0] = nexUtils.date2Utc(nexUtils.dateAdd(datePoint, interval, unit * up_cnt));
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
        var date_utc_time = chartData[point][0],
          williams = 0;

        if (point - this._day >= 0) {
          var toate_close_price = chartData[point][4],
            dates_high_price = nexChartUtils.getHighMax(point, this._day, chartData),
            dates_Low_price = nexChartUtils.getLowMin(point, this._day, chartData);

          williams = Number((toate_close_price - dates_high_price) / (dates_high_price - dates_Low_price) * 100);

          this._data[exceptFlag ? (this._exceptIdx - 1) : point] = [Number(date_utc_time), Number((Math.round(williams * 100)) / 100)];
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
   * desc : roc 데이터 객체(roc)
   * date : 2015.07.22
   * 
   */
  var rocData = function(chart, seqId, chartData, day) {
	 this._chart = chart;
    this._type = 'roc';
    this._id = seqId;
    this._data1 = []; // roc
    this._data2 = []; // 시그널선
    this._day = day; // 기간

    this._exceptIdx = [];

    this.arr_signal = [];

    this.init();
    this.setData(chartData);
  }
  rocData.prototype = {
    init: function() {
      this._exceptIdx[0] = 0;
      this._exceptIdx[1] = 0;

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
     * ROC (Price Rate Of Change)계산식
     * roc = (당일종가/n일전종가)*100 (기본설정값 : 기간 12일, 시그널 9일 고정)
     * @param chartData : 차트 데이터
     */
    setData: function(chartData) {
      if (chartData != null && chartData.length > 0) {
        var roc_val = 0;
        for (var i = this._day, len = chartData.length; i < len; i++) {
          if (typeof chartData[i][6] == 'undefined' || chartData[i][6] == null || chartData[i][6] != 'except') {
            // roc구하기
            roc_val = Number((chartData[i][4] / chartData[i - this._day][4]) * 100);
            this._data1.push([Number(chartData[i][0]), Number(roc_val.toFixed(2))]);
            this._exceptIdx[0]++;

            // 시그널선 계산 (시그널 기간설정값 signal_day = 9일 고정)
            var signal_day = 9;
            if (i == this._day) { // i가 12 일때, 초기값은 roc_val 값을 그대로 사용
              this.arr_signal[i] = roc_val;
            } else { // i가 10 보다 클때
              this.arr_signal[i] = (roc_val * (2 / (signal_day + 1))) + this.arr_signal[i - 1] * (1 - (2 / (signal_day + 1)));
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
            data[j][0] = nexUtils.date2Utc(nexUtils.dateAdd(datePoint, interval, unit * up_cnt));
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
        var roc_val = Number((chartData[point][4] / chartData[point - this._day][4]) * 100);
        this._data1[exceptFlag ? (this._exceptIdx[0] - 1) : point] = [Number(date_utc_time), Number(roc_val.toFixed(2))];

        // 시그널선 계산 (시그널 기간설정값 signal_day = 9일 고정)
        var signal_day = 9;
        if (point == this._day) { // i가 12 일때, 초기값은 roc_val 값을 그대로 사용
          this.arr_signal[point] = roc_val;
        } else { // i가 10 보다 클때
          this.arr_signal[point] = (roc_val * (2 / (signal_day + 1))) + this.arr_signal[point - 1] * (1 - (2 / (signal_day + 1)));
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

  window.nexChart = nexChart;
})(window, jQuery);

// **********************************************************
// ********************* end nexChart ***********************
// **********************************************************

(function(window, $, undefined) {
  /**
   * desc : 주식 종합 차트 UI옵션
   * date : 2015.07.22
   * author : 김행선
   * @param chartElement 
   * @param viewName
   * @parma chart
   */
  var nexTotalChart = function(chartElement, viewName, chart) {
    this._viewName	 	= viewName; // 화면 번호
    this._tmpId 		= '#mdi' + this._viewName;
    this._chart			= chart; // 차트 객체
    this._monthSect 	= '2'; // 기본값
    this._channelInCnt 	= $('.indicator:checked').length;
    this._secondInCnt 	= $('.assistant:checked').length;

    // 종합차트 설정부분 SELECOR 지정
    this.CHART_ELMT 	= chartElement; // 차트
    this.RANGE_BTN 		= $(this._tmpId).find('datetime'); // 일,주,월,분,시 버튼
    this.INDICATOR_CKBX	= $(this._tmpId).find('.indicator'); // 지표설정 checkbox
    this.ASSISTANT_CKBX	= $(this._tmpId).find('.assistant'); // 보조차트 checkbox
    this.USER_IN_CBBX 	= $(this._tmpId).find('#userIn1, #userIn2'); // 상세주기 콤보박스(일주월분, 시)
    this.INDICATOR_CBBX	= $(this._tmpId).find('#indicator_list'); // 설정 콤보박스
    this.SEARCH_BTN 	= $(this._tmpId).find('#search'); // 조회 버튼
    this.DEFAULT_BTN	= $(this._tmpId).find('.defaultbtn'); // 설정 기본 버튼
    this.APPLY_BTN		= $(this._tmpId).find('.applybtn'); // 설정 적용 버튼
    this.PLUS_BTN		= $(this._tmpId).find('.pbtn'); // 설정 + 버튼
    this.MINUS_BTN		= $(this._tmpId).find('.mbtn'); // 설정 - 버튼

    // 채널지표 key & value
    this.INDICATOR_ID = {
      '000': 'candle', 		// 캔들차트
      '001': 'sma', 		// 이동평균선
      '002': 'cna', 		// 일목균형지표
      '011': 'bollinger',	// 볼린저밴드지표
      '031': 'envelope', 	// 엔벨로프
      '041': 'maribbon' 	// 그물지표
    };
    
    // 보조지표 key & value
    this.ASSISTANT_ID = {
      '051': 'volume',	// 거래량
      '061': 'macd', 	// MACD
      '071': 'slowStc', // Stochastic Slow
      '081': 'cci', 	// CCI
      '091': 'mental', 	// 심리도
      '101': 'adx',	 	// ADX
      '111': 'obv', 	// OBV
      '121': 'sonar',	// SONAR
      '131': 'vr', 		// VR
      '141': 'trix', 	// TRIX
      '171': 'roc' 		// ROC
    };
    
    // 지표 설정 값(기본값)
    this._defaultVar = {
      '001': [5, 20, 60, 120],		// 이동평균
      '002': [26, 9, 26, 26, 52],	// 일목균형
      '011': [20],					// Bollinger Bands
      '031': [13, 8], 				// Envelop
      '041': [5, 1, 15], 			// 그물차트
      '061': [12, 26, 9], 			// MACD
      '071': [10, 5, 5], 			// Stochastic Slow(slowstc)
      '081': [14], 					// CCI
      '091': [10], 					// 심리도(mental)
      '101': [14], 					// ADX
      '111': [9], 					// OBV
      '121': [20, 9, 9], 			// SONAR
      '131': [20], 					// VR
      '141': [12, 9], 				// TRIX
      '171': [12] 					// ROC
    };
    this._cookieVar = this._getCookieVariables(); // this._defaultVar을 쿠키에 저장

    this._onEvent(); // 화면 이벤트 처리
    this._init(); // 초기화
  }
  nexTotalChart.prototype = {
    /**
     * desc : 초기화
     * date : 2015.07.22
     */
    _init: function() {
      this._firstDraw();
    },
    /**
     * desc : 최초에 차트 생성시, 지표 추가
     * date : 2015.07.22
     * author : 김행선
     */
    _firstDraw: function() {
      var self = this;
      
      this._addSeries('000', false);
      // 체크박스 checked 상태인 지표 생성, 추가
      $(self._tmpId).find('input:checkbox').each(function(index) { 
        if ($(this).is(':checked')) {
          self._addYaxis($(this).val(), false);
          self._addSeries($(this).val(), false);
        }
      });
      
      self._chart.redraw();
    },
    /**
     * desc : 폼에 입력된 데이터를 쿠키에 저장
     * date : 2015.07.22
     * author : 김행선
     * @param type : 지표 및 보조차트 타입('000', '010', ...)
     */
    _saveVariables: function(type) {
      var $selector = $(this._tmpId).find('[id^=var' + type + ']');
      var len = $selector.length;
      var bind_data = [];
      for (var i = 1; i < len; i++) {
        bind_data.push(Number($selector[i].value));
      }

      if (bind_data.length > 0) {
        this._cookieVar[type] = bind_data;
        this._setCookieVariables(this._cookieVar);
        nexMdi.getCtl(this._viewName).search();
      }
    },
    /**
     * desc : 쿠키 값 또는 기본 설정 값을 폼에 입력
     * date : 2015.07.22
     * author : 김행선
     * @param type : 지표 및 보조차트 타입('000', '010', ...)
     * @param isDefault : default값으로 셋팅할 경우 true
     */
    _setBindVariables: function(type, isDefault) {
      var bind_data = isDefault ? this._defaultVar : this._cookieVar;

      for (var i = 0; i < bind_data[type].length; i++) {
        $(this._tmpId).find('#var' + type + '_input' + String(i)).val(bind_data[type][i]);
        this._cookieVar[type] = bind_data[type].slice();
      }

      if (isDefault) { // 쿠키에 기본 설정값을 쓰고, 차트 갱신
        this._setCookieVariables(this._defaultVar);
        nexMdi.getCtl(this._viewName).search();
      }
    },
    /**
     * desc : SET 쿠키
     * date : 2015.07.22
     * author : 김행선
     * @param jsonData : 차트, 보조차트의 설정값(this._defaultVar, this._cookieVar)
     */
    _setCookieVariables: function(jsonData) {
      try {
        $.cookie('cookieVariables' + this._viewName, JSON.stringify(jsonData), {
          expires: 365
        });
      } catch (err) {;
      }
    },
    /**
     * desc : GET 쿠키
     * date : 2015.07.22
     * author : 김행선
     */
    _getCookieVariables: function() {
      if ($.cookie('cookieVariables' + this._viewName) == undefined) {
        this._setCookieVariables(this._defaultVar);
      }

      var rtnData = this._defaultVar;

      if ($.cookie('cookieVariables' + this._viewName) != undefined) {
        rtnData = JSON.parse($.cookie('cookieVariables' + this._viewName));
      }

      return rtnData;
    },
    /**
     * desc : 시리즈 추가
     * date : 2015.07.22
     * author : 김행선
     * @param type : 지표 및 보조차트 타입('000', '010', ...)
     * @param draw : true일 경우, 시리즈 추가한 뒤 차트 redraw
     */
    _addSeries: function(type, draw) {
      var yAxis_name = '';
      var setting_data = this.INDICATOR_ID[type] == 'candle' ? null : this._cookieVar[type];
      var series_id = this.INDICATOR_ID[type] ? this.INDICATOR_ID[type] : this.ASSISTANT_ID[type]

      if (this.INDICATOR_ID[type]) {
        yAxis_name = 'mainYaxis';
      } else {
        yAxis_name = series_id + 'Yaxis';
      }

      this._chart.addSeries(series_id + 'Series', yAxis_name, setting_data);

      if (draw == true) {
        this._chart.redraw();
      }
    },
    /**
     * desc : 시리즈 삭제
     * date : 2015.07.22
     * author : 김행선
     * @param type : 지표 및 보조차트 타입('000', '010', ...)
     * @param draw : true일 경우, 시리즈 삭제한 뒤 차트 redraw
     */
    _removeSeries: function(type, draw) {
      var series_id = this.INDICATOR_ID[type] ? this.INDICATOR_ID[type] : this.ASSISTANT_ID[type]

      this._chart.removeSeries(series_id + 'Series');

      if (draw == true) {
        this._chart.redraw();
      }
    },
    /**
     * desc : Y축 추가
     * date : 2015.07.22
     * author : 김행선
     * @param type : 지표 및 보조차트 타입('000', '010', ...)
     * @param draw : true일 경우, Y축 추가한 뒤 차트 redraw
     */
    _addYaxis: function(type, draw) {
      if (this.INDICATOR_ID[type]) { // 채널지표는 Y축 추가할 필요 없음
        return;
      }

      this._chart.addYAxis(this.ASSISTANT_ID[type] + 'Yaxis');

      if (draw == true) {
        this._chart.redraw();
      }
    },
    /**
     * desc : Y축 삭제
     * date : 2015.07.22
     * author : 김행선
     * @param type : 지표 및 보조차트 타입('000', '010', ...)
     * @param draw : true일 경우, Y축 삭제한 뒤 차트 redraw
     */
    _removeYaxis: function(type, draw) {
      var series_id = this.INDICATOR_ID[type] ? this.INDICATOR_ID[type] : this.ASSISTANT_ID[type]

      this._chart.removeYAxis(series_id + 'Yaxis');

      if (draw == true) {
        this._chart.redraw();
      }
    },
    /**
     * desc : 차트관련 모든 데이터 삭제
     * date : 2015.07.22
     * author : 김행선
     */
    _chartdestroy: function() {
      var chart_area = this.CHART_ELMT;
      if (chart_area.length > 0) {
        if (chart_area.highcharts()) {
          chart_area.highcharts().destroy();
        }

        if (this._chart != undefined && this._chart != null) {
          this._chart.destroy();
          delete this._chart;
          this._chart = null;
        }

        delete nexMdi.getCtl(this._viewName)._data['chartData'];
        nexMdi.getCtl(this._viewName)._data['chartData'] = null;
      } else {
        //logger.log("_chartdestroy 대상없음!");
      }
    },
    /**
     * desc : 차트 완전 제거 후, 재 생성
     * date : 2015.07.22
     * author : 김행선
     */
    _refreshChart: function() {
      //self.eliminate('D');
      this._chartdestroy();
      nexMdi.getCtl(this._viewName).getSearchHeaderData();
    },
    /**
     * desc : 화면단 이벤트 처리
     * date : 2015.07.22
     * author : 김행선
     */
    _onEvent: function() {
      var self = this;

      //$(document).tabs();

      //일,주,월,분,시,틱 변경시
      self.RANGE_BTN.each(function(index) {
        $(this).unbind('click').click(function() {
          switch (index) {
            case '0': //일간
              this._monthSect = '2';
              break;
            case '1': //주
              this._monthSect = '3';
              break;
            case '2': //월
              this._monthSect = '4';
              break;
            case '3': //분
              this._monthSect = '1';
              break;
            case '4': //시
              this._monthSect = '7';
              break;
            case '5': //틱
              this._monthSect = '0';
              break;
          }

          if (index == '4') {
            $(userIn1).val('1').hide();
            $(userIn2).val('60').show();
          } else {
            $(userIn2).val('60').hide();
            $(userIn1).val('1').show();
          }

          self.RANGE_BTN.removeClass('on');
          $(this).addClass('on');

          self._refreshChart();
        });
      });

      //채널지표 선택시.
      self.INDICATOR_CKBX.each(function(index) {
        $(this).unbind('change').change(function() {
          if ($(this).is(':checked')) {
            if (self._channelInCnt < 3) {
              // 일목균형일 경우 빈데이터 추가해야 하기때문에 다시 그린다.
              if (self.INDICATOR_ID[$(this).val()] == 'cna') {
                nexMdi.getCtl(self._viewName).search();
                self._channelInCnt++;
              } else {
                self._addSeries($(this).val(), true);
                self._channelInCnt++;
              }
            } else {
              $(this).attr("checked", false);
              //nexMdiCommon.wtsHistoryMsg('0002', '채널지표는 3개까지 선택할 수 있습니다.');
              alert('채널지표는 3개까지 선택할 수 있습니다.');
            }
          } else {
            if (self._channelInCnt > 0 && self._channelInCnt < 4) {

              // 일목균형일 경우 빈데이터 추가한 데이터 삭제해야 하기때문에 다시 그린다.
              if (self.INDICATOR_ID[$(this).val()] == 'cna') {
                nexMdi.getCtl(self._viewName).search();
                self._channelInCnt--;
              } else {
                self._removeSeries($(this).val(), true);
                self._channelInCnt--;
              }
            }
          }
        });
      });

      //보조지표 선택시.
      self.ASSISTANT_CKBX.each(function(index) {
        $(this).unbind('change').change(function() {
          if ($(this).is(':checked')) {
            if (self._secondInCnt < 3) {
              self._addYaxis($(this).val(), false);
              self._addSeries($(this).val(), true);
              self._secondInCnt++;
            } else {
              $(this).attr("checked", false);
              //nexMdiCommon.wtsHistoryMsg('0002', '보조지표는 3개까지 선택할 수 있습니다.');
              alert('보조지표는 3개까지 선택할 수 있습니다.');
            }
          } else {
            if (self._secondInCnt > 0 && self._secondInCnt < 4) {
              self._removeSeries($(this).val(), false);
              self._removeYaxis($(this).val(), true);
              self._secondInCnt--;
            }
          }
        });
      });

      //설정 콤보박스 변경시.
      self.INDICATOR_CBBX.unbind('change').change(function() {
        $(self._tmpId).find('.set_list').hide();
        $(self._tmpId).find('#var' + $(this).val()).show();
        self._setBindVariables($(this).val());
      });

      //상세 단위 변경시
      self.USER_IN_CBBX.unbind('change').change(function() {
        self._refreshChart();
      });

      //조회 버튼 클릭시
      self.SEARCH_BTN.unbind('click').click(function() {
        nexMdi.getCtl(self._viewName).search();
      });

      //기본 버튼 클릭시
      self.DEFAULT_BTN.each(function(index, value) {
        $(this).unbind('click').click(function() {
          var id = $(this).parent().parent().find('input[type=text]').attr('id');
          var type = id.slice(3, 6);
          self._setBindVariables(type, true);
        });
      });

      //적용 버튼 클릭시
      self.APPLY_BTN.each(function(index, value) {
        $(this).unbind('click').click(function() {
          var id = $(this).parent().parent().find('input[type=text]').attr('id');
          var type = id.slice(3, 6);
          self._saveVariables(type);
        });
      });

      //+ 버튼 클릭시
      self.PLUS_BTN.each(function(index, value) {
        $(this).unbind('click').click(function() {
          var $input = $(this).parent().find('input[type=text]');

          var type = $input.attr('id').slice(3, 6);;
          var input_value = Number($input.val());

          if (self.INDICATOR_ID[type] == 'sma') {
            if (input_value >= 300) {
              $input.val(300);
            } else {
              $input.val(input_value + 1);
            }
          } else {
            if (input_value >= 100) {
              $input.val(100);
            } else {
              $input.val(input_value + 1);
            }
          }
        });
      });

      //- 버튼 클릭시
      self.MINUS_BTN.each(function(index, value) {
        $(this).unbind('click').click(function() {
          var $input = $(this).parent().find('input[type=text]');

          var type = $input.attr('id').slice(3, 6);;
          var input_value = Number($input.val());

          if (input_value <= 1) {
            $input.val(1);
          } else {
            $input.val(input_value - 1);
          }
        });
      });

      self._setBindVariables('001'); //설정 탭 첫번째 콤보박스 셋(이동평균)
    }
  }
  
  window.nexTotalChart = nexTotalChart;
})(window, jQuery)