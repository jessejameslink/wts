(function(window, $, undefined) {
	var nexMdi=function() {
		this.PREFIX='mdi';
		this.viewsName=[];
		this.viewsInfo=[];
		this.openWins=[];
		//this.viewScope=[];
		this.tabLoadCnt=[];
		this._arrayFunc=[];
		this._ctlLoadFail = [];
		this.defaultRefCode='037620';
		this._tabSearchCheckCnt=0;
	};

	nexMdi.prototype.add = function(resources){
			var self=this;
			self.viewsName.push(resources.viewName);
			self.viewsInfo.push({
								viewName:resources.viewName,
								title:resources.titleName,
								taskTitle:resources.taskName,
								width:resources.width,
								height:resources.height,
								market:resources.market,
								listen:resources.listen,
								rolesType:resources.rolesType});

			if(resources.titleName!==undefined && resources.titleName!='' )	{

				resources.module.directive(self.PREFIX+resources.viewName, function() {
							return {
								restrict: 'A',
								templateUrl: '/advancement/jsp/trading/html/views/'+self.PREFIX+resources.viewName+'.html',
								scope: {view: '='},
								priority: 0,
								replace: true,
								require: '^nexMdiWindow',
								controller: self.PREFIX+resources.viewName+'Controller'
								, link: function(scope, element, attrs, windowCtrl) {
									scope.windowCtrl = windowCtrl;
									windowCtrl.setWindowTitle(resources.titleName);
									windowCtrl.setWindowViewNo('['+resources.viewName+']');
									windowCtrl.setWindowTaskTitle(resources.taskName);
									scope.info={
											viewName:resources.viewName,
											title:resources.titleName,
											taskTitle:resources.taskName,
											size:resources.size,
											market:resources.market,
											listen:resources.listen,
											fid:{},
											oop:{},
											real:{},
											rolesType:resources.rolesType};
	
									var $selectors=$('#mdi'+resources.viewName).find('[fid^=F]');
									
									var _real=scope.info.real, _fid=scope.info.fid, _oop=scope.info.oop;
									for(var i=$selectors.length;i--;){
										var $selector=$($selectors[i]);
										var arr_fid=$selector.attr('fid').split(',');
										var fid=arr_fid[1].trim();
										var oop=arr_fid[2].trim();
										var real=arr_fid[3].trim();

										if(typeof _real[real] =='undefined') {
											_real[real]=[];
										}

										if(typeof _fid[fid] =='undefined') {
											_fid[fid]=[];
										}

										if(typeof _oop[oop] =='undefined') {
											_oop[oop]=[];
										}

										var func=$selector.attr('func');
										var func_obj=null;

										if(func) {
											try	{
												func_obj = eval(func);
											}catch (err){
												;
											}
										}

										var fmt=$selector.attr('fmt');
										var fmt_obj=null;

										if(fmt) {
											fmt_obj=fmt;
										}

										if(fid!='')		_fid[fid].push({selector:$selector, func:func_obj, fmt:fmt_obj});
										if(real!='')	_real[real].push({selector:$selector, func:func_obj, fmt:fmt_obj});
										if(oop!='')		_oop[oop].push({selector:$selector, func:func_obj, fmt:fmt_obj});
									}

									//self.viewScope.push(scope);

									//최근 본화면 추가
									cmmUtils.historyListAdd(resources.viewName);

									//즐겨찾기 확인
									if(cmmUtils.favData.indexOf(resources.viewName) > -1)
										$('#mdi'+resources.viewName+'_FavBtn').removeClass('not');

									//탭 처리 공통
									var $mdi_selector=$('#mdi'+resources.viewName);
									$mdi_selector.find('[name^=tabs]').tabs();
									$mdi_selector.find( "select" ).selectmenu();

									$mdi_selector.find('.datepicker').datepicker({
										showOn: "button",
										buttonText: "Select date",
										changeMonth: true,
										changeYear: true,
										dateFormat: "yy/mm/dd",
										showMonthAfterYear: true,
										dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'],
										monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
									});
									
									
									$mdi_selector.find('input').placeholder();
									$mdi_selector.find('textarea').placeholder();
									$mdi_selector.find('.datepicker').placeholder();

									//기업정보 버튼 이벤트
									$mdi_selector.find('[name^=corpo_info]').attr('viewName', resources.viewName);
									$mdi_selector.find('[name^=corpo_info]').on('click', function(){
										var option = {viewName:'00002', parentName:$(this).attr('viewName'), position:'element-bottom-right', positionTagName:'corpo_info', bgClickHide:true, x:-15, y:-17};
										nexDialog.open(option);
									});

									//종목검색 버튼 이벤트
									$mdi_selector.find('[name^=refcode_search]').attr('viewName', resources.viewName);
									$mdi_selector.find('[name^=refcode_search]').on('click', function(){
										var $this_selector=$(this);
										var ref_code_link=$this_selector.attr("refCodeLink");
										var ref_code=$this_selector.attr("refCode");
										var ref_name=$this_selector.attr("refName");

										if(ref_code_link == undefined || ref_code_link== null)
											ref_code_link='';
										if(ref_code == undefined || ref_code== null)
											ref_code='';
										if(ref_name == undefined || ref_name== null)
											ref_name='';

										var value_data={refCodeLink:ref_code_link, refCode:ref_code, refName:ref_name};
										var option = {viewName:'00000', parentName:$this_selector.attr('viewName'), position:'element-bottom-right', positionTagName:$this_selector.attr('name'), bgClickHide:true, x:-95, y:3, value:value_data};
										nexDialog.open(option);
									});
									
									//선물옵션종목검색 버튼 이벤트
									$mdi_selector.find('[name^=fnocode_search]').attr('viewName', resources.viewName);
									$mdi_selector.find('[name^=fnocode_search]').on('click', function(){
										var $this_selector=$(this);
										var option = {viewName:'03000', parentName:$this_selector.attr('viewName'), position:'element-bottom-right', positionTagName:$this_selector.attr('name'), bgClickHide:true, x:-95, y:5};
										nexDialog.open(option);
									});

									//업종종목검색 버튼 이벤트 - init Attribute => 업종분류(0:코스피, 2:코스닥, 1:코스피200, 4:코스피100)
									$mdi_selector.find('[name^=upjcode_search]').attr('viewName', resources.viewName);
									$mdi_selector.find('[name^=upjcode_search]').on('click', function(){
										var $this_selector=$(this);
										var up_code=$this_selector.attr("upCode");
										var up_name=$this_selector.attr("upName");
										if(up_code == undefined || up_code== null)
											up_code="upjongCode";
										if(up_name == undefined || up_name== null)
											up_name='upjongName';
										var option = {viewName:'05000', parentName:$this_selector.attr('viewName'), position:'element-bottom-right', positionTagName:up_code, bgClickHide:true, x:-15, y:5, value:{jgub : $(this).attr('init'), upCode:up_code, upName:up_name}};
										nexDialog.open(option);
									});

									//선물옵션종목 업 버튼 이벤트
									$mdi_selector.find('[name^=fnocode_up]').attr('viewName', resources.viewName);
									$mdi_selector.find('[name^=fnocode_up]').on('click', function(){
										var $this_selector=$(this);
										var fno_code=$("#mdi"+resources.viewName+" .search_area input[name=fnoCode1]").val()
											        +$("#mdi"+resources.viewName+" .search_area input[name=fnoCode2]").val();

										if(fno_code == undefined || fno_code== null)
											fno_code='';

										var marketType = cmmUtils.getMarket(fno_code);

										// 선물, 스프레드는 "000"만 있음.
										if (marketType == cmmUtils.CODE_FUTURE_D || marketType == cmmUtils.CODE_SPREAD_D) {
											return;
										}

										var data = [];
										if (marketType == cmmUtils.CODE_OPTION_D) {
											data = MasterCode.OPTION.Name;
										} else if (marketType == cmmUtils.CODE_MOPTION_D) {
											data = MasterCode.MINIOPTION.Name;
										}

										var upCode = "";
										for(var i = data.length - 1; i >= 0; i--) {
											if(data[i].ITM_CD.substring(0,5)==fno_code.substring(0,5)) {
												if (data[i].ITM_CD==fno_code) {
													break;
												}
												upCode = data[i].ITM_CD;
											}
										}

										if (upCode == '') return; // 최상위
										fno_code = upCode;

										window.nexMdi.setAllFnoCode(fno_code, $this_selector.attr('viewName'));
									});

									//선물옵션종목 다운 버튼 이벤트
									$mdi_selector.find('[name^=fnocode_down]').attr('viewName', resources.viewName);
									$mdi_selector.find('[name^=fnocode_down]').on('click', function(){
										var $this_selector=$(this);
										var fno_code=$("#mdi"+resources.viewName+" .search_area input[name=fnoCode1]").val()
											        +$("#mdi"+resources.viewName+" .search_area input[name=fnoCode2]").val();

										if(fno_code == undefined || fno_code== null)
											fno_code='';

										var marketType = cmmUtils.getMarket(fno_code);

										// 선물, 스프레드는 "000"만 있음.
										if (marketType == cmmUtils.CODE_FUTURE_D || marketType == cmmUtils.CODE_SPREAD_D) {
											return;
										}

										var data = [];
										if (marketType == cmmUtils.CODE_OPTION_D) {
											data = MasterCode.OPTION.Name;
										} else if (marketType == cmmUtils.CODE_MOPTION_D) {
											data = MasterCode.MINIOPTION.Name;
										}

										var downCode = "";
										for(var i = 0, len = data.length; i < len; i++) {
											if(data[i].ITM_CD.substring(0,5)==fno_code.substring(0,5)) {
												if (data[i].ITM_CD==fno_code) {
													break;
												}
												downCode = data[i].ITM_CD;
											}
										}

										if (downCode == '') return; // 최하위
										fno_code = downCode;

										window.nexMdi.setAllFnoCode(fno_code, $this_selector.attr('viewName'));
									});

									//선물옵션 선버튼 클릭 (최근 종목 중 선물 선택, 최근 종목이 없을 경우 mastercode에서 첫번째 선물)
									$mdi_selector.find('[name^=fnocode_future]').on('click', function(){
										var fno_code = '';
										var marketType = '';
										for (var i = 0, len = cmmUtils.fnoLatelyData.length; i < len; i++) {
											marketType = cmmUtils.getMarket(cmmUtils.fnoLatelyData[i].fnoCode);
											if (marketType == cmmUtils.CODE_FUTURE_D || marketType == cmmUtils.CODE_SPREAD_D) {
												fno_code = cmmUtils.fnoLatelyData[i].fnoCode;
												break;
											}
										}
										
										// 최근 종목이 없거나, 최근 종목에 선물이 없을 경우
										if (fno_code == '') {
											fno_code=MasterCode.FUTURE[0].ITM_CD;
										}
										
										window.nexMdi.setAllFnoCode(fno_code, resources.viewName);
									});

									//선물옵션 콜버튼 클릭 (최근 종목 중 콜옵션 선택, 최근 종목이 없을 경우 mastercode에서 첫번째 콜옵션)
									$mdi_selector.find('[name^=fnocode_call]').on('click', function(){
										var fno_code = '';
										var marketType = '';
										for (var i = 0, len = cmmUtils.fnoLatelyData.length; i < len; i++) {
											marketType = cmmUtils.getMarket(cmmUtils.fnoLatelyData[i].fnoCode);
											if (marketType == cmmUtils.CODE_OPTION_D || marketType == cmmUtils.CODE_MOPTION_D) {
												if (cmmUtils.fnoLatelyData[i].fnoCode.substring(0,1) == '2') {
													fno_code = cmmUtils.fnoLatelyData[i].fnoCode;
													break;
												}
											}
										}

										// 최근 종목이 없거나, 최근 종목에 콜옵션이 없을 경우
										if (fno_code == '') {
											for (var i = 0, len = MasterCode.OPTION.Name.length; i < len; i++) {
												if (MasterCode.OPTION.Name[i].ITM_CD.substring(0,1) == '2') {
													fno_code = MasterCode.OPTION.Name[i].ITM_CD;
													break;
												}
											}
										}
										
										window.nexMdi.setAllFnoCode(fno_code, resources.viewName);
									});

									//선물옵션 풋버튼 클릭 (최근 종목 중 풋옵션 선택, 최근 종목이 없을 경우 mastercode에서 첫번째 풋옵션)
									$mdi_selector.find('[name^=fnocode_put]').on('click', function(){
										var fno_code = '';
										var marketType = '';
										for (var i = 0, len = cmmUtils.fnoLatelyData.length; i < len; i++) {
											marketType = cmmUtils.getMarket(cmmUtils.fnoLatelyData[i].fnoCode);
											if (marketType == cmmUtils.CODE_OPTION_D || marketType == cmmUtils.CODE_MOPTION_D) {
												if (cmmUtils.fnoLatelyData[i].fnoCode.substring(0,1) == '3') {
													fno_code = cmmUtils.fnoLatelyData[i].fnoCode;
													break;
												}
											}
										}

										// 최근 종목이 없거나, 최근 종목에 콜옵션이 없을 경우
										if (fno_code == '') {
											for (var i = 0, len = MasterCode.OPTION.Name.length; i < len; i++) {
												if (MasterCode.OPTION.Name[i].ITM_CD.substring(0,1) == '3') {
													fno_code = MasterCode.OPTION.Name[i].ITM_CD;
													break;
												}
											}
										}
										
										window.nexMdi.setAllFnoCode(fno_code, resources.viewName);
									});

									window.nexMdi.tabEvent(resources.viewName);
									window.nexMdi.activeTabSearch(resources.viewName);

									window.nexMdi.mdiAllLock(cmmUtils.configInfo.normal.marketLink);

									var $ref_code_selector=$("#mdi"+resources.viewName+" .search_area input[name=refCode]");

									 $ref_code_selector.attr('viewName', resources.viewName);
									 $ref_code_selector.keyup(function(event){
											var $this_selector=$(this);
											var ref_code=$this_selector.val().trim();

											window.nexMdi.setAllRefCode(ref_code, $this_selector.attr('viewName'));
										
											/*
											var jongmok_data=cmmUtils.getJongmokData(ref_code);

											if(jongmok_data!=null) {
												var nex_mdi=window.nexMdi;
												var nm='';
												if(jongmok_data.gbn=='MINIOPTION' || jongmok_data.gbn=='OPTION') {
													nm=jongmok_data.value.ITMN;
												} else {
													nm=jongmok_data.value.KOR_ITMN;
												}

												var $ref_code_selector1=$("#mdi"+$this_selector.attr('viewName')+" .search_area input[name=refCode]");
												var len1 =$ref_code_selector1.length;

												if( len1>=1) {
													for(var k=0;k<len1;k++) {
														$($ref_code_selector1[k]).val(ref_code);
													}
												}

												if(ref_code.length>=6 && event.keyCode!=13) {
													nex_mdi.getCtl($this_selector.attr('viewName')).search();
													
													var open_wins=nex_mdi.openWins;
													for(var i=0, len=open_wins.length;i<len;i++){
														if(open_wins[i].viewInfo.market.indexOf(jongmok_data.gbn)>-1) {
															var vName=open_wins[i].viewName;
															if(vName!=$this_selector.attr('viewName') && !open_wins[i].lockCheck) {
																var $ref_code_selector2=$("#mdi"+vName+" .search_area input[name=refCode]");
																var len3 =$ref_code_selector2.length;
																if( len3>=1) {
																	for(var k=0;k<len3;k++) {
																		$($ref_code_selector2[k]).val(ref_code);
																	}
																}

																if(ref_code.length>=6 && event.keyCode!=13) {
																	nex_mdi.getCtl(vName).search();
																}
															}
														}
													}
												}
											}
											*/
									 });

									 $ref_code_selector.focus(function(){
											var $this_selector=$(this);
											var ref_code=$this_selector.val().trim();
											if(ref_code.length>=6) {
												$this_selector[0].refCode=$this_selector.val();
												$this_selector.val('');
											}
									 });

									 $ref_code_selector.blur(function(){
											var $this_selector=$(this);
											var ref_code=$this_selector.val().trim();
											if(ref_code.length<6) {
												$this_selector.val($this_selector[0].refCode);
											}
									 });

									 $ref_code_selector.keypress(function(event){
											if(event.keyCode==13) {
												return false;
											}
									 });

									 var $upjong_code_selector=$("#mdi"+resources.viewName+" .search_area input[name^=upjongCode]");

									 $upjong_code_selector.attr('viewName', resources.viewName);
									 $upjong_code_selector.keyup(function(event){
											var $this_selector=$(this);
											var searchCheck = false;
											var upjong_code = $this_selector.val().trim();
											var upjongData	= MasterCode.UPJONG;
											if(upjongData!=null) {
												if(upjong_code.length==2 && event.keyCode!=13) {
													var upjong_jgub = $(this).parent().find('[name^=upjcode_search]').attr('init');
													for (var i=0, len=upjongData.length; i < len; i++) {
														if (upjongData[i].JGUB == upjong_jgub && Number(upjongData[i].UCOD) == Number(upjong_code)){
															$(this).parent().find("[name^=upjongName]").val(upjongData[i].HNAM);
															searchCheck = true;
															break;
														}
													}
													if(searchCheck)
														window.nexMdi.getCtl($this_selector.attr('viewName')).search();
													else
														$("#mdi"+$this_selector.attr('viewName')).find("[name^=upjongName]").val("종목코드오류");
												}
											}
									 });
								}
							};
						}
					);
			}

			resources.module.controller(self.PREFIX+resources.viewName + 'Controller', ['$scope',function($scope){
				self.ctlLoad({scope:$scope,viewName:resources.viewName,parentName:resources.parentName,type:'main',value:$scope.view.value});
			}]);
	};

	// 컨트롤러 함수배열안에 해당하는 컨트롤러 있을 경우 로드, 없을경우 함수배열에 추가 후 컨트롤러 로드
	nexMdi.prototype.ctlLoad=function(resources) {
		var self=this;
		if(resources.parentName===undefined)
			resources.parentName=resources.viewName;

		var full_view_name=resources.parentName+'_'+resources.viewName;
		var arr_func=self._arrayFunc;
		var arr_fail=self._ctlLoadFail;

		var loadCheck = false;
		for(var i = arr_fail.length; i--;) {
			if(arr_fail[i].viewName == full_view_name) {
				loadCheck = true;
				break;
			}
		}

		if(!loadCheck) {
			var loadObj = {};
			loadObj.viewName = full_view_name;
			loadObj.FailCnt = 0;
			arr_fail.push(loadObj);
		}

		var k=0,check=false;
		var len=arr_func.length;
		for(k=0;k<len;k++) {
			if(arr_func[k].viewName==full_view_name) {
				check=true;
				break;
			}
		}

		if(!check) {
			require(['controller/' +self.PREFIX+ resources.viewName], function requireSuccess(func) {
				var self=window.nexMdi;
				var arr_func=self._arrayFunc;
				var arr_fail=self._ctlLoadFail;

				for(var i = 0, len = arr_fail.length; i < len; i++) {
					if(arr_fail[i].viewName == full_view_name) {
						arr_fail.splice(i, 1);
						break;
					}
				}



				//if(!check) {
					var tempFunc = new func();
					var obj = {};
					obj.viewName = full_view_name;
					obj.func = tempFunc;
					arr_func.push(obj);
					tempFunc.init(resources.scope, resources.type, resources.value);
				//} else {
				//	self._arrayFunc[i].func.init(resources.scope, resources.type, resources.value);
				//}
			}, function requireFail(err) {
				var self=window.nexMdi;
				var arr_func=self._arrayFunc;
				var arr_fail=self._ctlLoadFail;

				for(var i = arr_fail.length; i--;) {
					if(arr_fail[i].viewName == full_view_name) {
						if(arr_fail[i].FailCnt < 10) {
							arr_fail[i].FailCnt++;
							self.ctlLoad(resources);
						} else {
							if(typeof printStackTrace != 'undefined') {
								var trace = printStackTrace({e: err});
								alert('controller/'+ self.PREFIX+resources.viewName+'.js file Load fail err >>>>>>>>>> [' + err + ']\n\n' + trace.join('\n\n'));
							} else {
								alert('controller/'+ self.PREFIX+resources.viewName+'.js file Load fail err >>>>>>>>>> ['+ err +']');
							}
						}
						break;
					}
				}
			});
		} else {
			self._arrayFunc[k].func.init(resources.scope, resources.type, resources.value);
		}
	};

	nexMdi.prototype.ctlTabLoad=function(resources) {
		var self=this;
		if(resources.parentName===undefined)
			resources.parentName=resources.viewName;

		var full_view_name=resources.parentName+'_'+resources.viewName;
		var arr_func=self._arrayFunc;
		var arr_fail=self._ctlLoadFail;

		var loadCheck = false;
		for(var i = arr_fail.length; i--;) {
			if(arr_fail[i].viewName == full_view_name) {
				loadCheck = true;
				break;
			}
		}

		if(!loadCheck) {
			var loadObj = {};
			loadObj.viewName = full_view_name;
			loadObj.FailCnt = 0;
			arr_fail.push(loadObj);
		}

		var k=0,check=false;
		var len=arr_func.length;
		for(k=0;k<len;k++) {
			if(arr_func[k].viewName==full_view_name) {
				check=true;
				break;
			}
		}

		if(!check) {
			require(['controller/' +self.PREFIX+ resources.viewName], function requireSuccess(func) {
				var self=window.nexMdi;
				var arr_func=self._arrayFunc;
				var arr_fail=self._ctlLoadFail;

				for(var i = 0, len = arr_fail.length; i < len; i++) {
					if(arr_fail[i].viewName == full_view_name) {
						arr_fail.splice(i, 1);
						break;
					}
				}



				//if(!check) {
					var tempFunc = new func();
					var obj = {};
					obj.viewName = full_view_name;
					obj.func = tempFunc;
					arr_func.push(obj);
					tempFunc.init(resources.scope, resources.type, resources.value);

					if(resources.search.toLowerCase()=='true')
						tempFunc.search();
				//} else {
				//	self._arrayFunc[i].func.init(resources.scope, resources.type, resources.value);
				//}
			}, function requireFail(err) {
				var self=window.nexMdi;
				var arr_func=self._arrayFunc;
				var arr_fail=self._ctlLoadFail;

				for(var i = arr_fail.length; i--;) {
					if(arr_fail[i].viewName == full_view_name) {
						if(arr_fail[i].FailCnt < 10) {
							arr_fail[i].FailCnt++;
							self.ctlLoad(resources);
						} else {
							if(typeof printStackTrace != 'undefined') {
								var trace = printStackTrace({e: err});
								alert('controller/'+ self.PREFIX+resources.viewName+'.js file Load fail err >>>>>>>>>> [' + err + ']\n\n' + trace.join('\n\n'));
							} else {
								alert('controller/'+ self.PREFIX+resources.viewName+'.js file Load fail err >>>>>>>>>> ['+ err +']');
							}
						}
						break;
					}
				}
			});
		} else {
			if(resources.init.toLowerCase()=='true')
				self._arrayFunc[k].func.init(resources.scope, resources.type, resources.value);

			if(resources.search.toLowerCase()=='true')
				self._arrayFunc[k].func.search(resources.value);
		}
	};

	// 메모리에 해당 컨트롤러 제거(소멸)
	nexMdi.prototype.ctlDestroy=function(resources) {
		var self=this;
		if(typeof resources.parentName=='undefined' || resources.parentName=='')
			resources.parentName=resources.viewName;

		var win_name='';
		if(resources.parentName==resources.viewName)
			win_name=resources.parentName+'_';
		else
			win_name=resources.parentName+'_'+resources.viewName;

		for(var i=self._arrayFunc.length;i--;) {
			if(self._arrayFunc[i].viewName.indexOf(win_name)>-1) {
				self._arrayFunc.splice(i, 1);
			}
		}
	};

	// 메모리에 해당하는 컨트롤러 있을 경우 실행(init)
	nexMdi.prototype.ctlRun=function(resources) {
		var self=this;
		if(typeof resources.parentName=='undefined' || resources.parentName=='')
			return;

		var arr_func=self._arrayFunc;
		var len=arr_func.length;
		var full_view_name=resources.parentName+'_'+resources.viewName;
		for(var i=0;i<len;i++) {
			if(arr_func[i].viewName==full_view_name) {
				arr_func[i].func.init(resources.scope, resources.type, resources.value);
				break;
			}
		}
		
	};

	// 메모리에 해당하는 컨트롤러 있을 경우 컨트롤러 리턴
	nexMdi.prototype.ctlRtn=function(resources) {
		var self=this;
		if(typeof resources.parentName=='undefined' || resources.parentName=='')
			return null;

		var arr_func=self._arrayFunc;
		var len=arr_func.length;
		var full_view_name=resources.parentName+'_'+resources.viewName;
		for(var i=0;i<len;i++) {
			if(arr_func[i].viewName==full_view_name) {
				return arr_func[i].func;
			}
		}
		return null;
	};

	// 메모리에 해당하는 컨트롤러 있을 경우 컨트롤러 리턴
	nexMdi.prototype.getCtl=function(parentName, viewName) {
		var self=this;
		if(typeof viewName=='undefined' || viewName=='')
			viewName=parentName;

		var arr_func=self._arrayFunc;
		var len=arr_func.length;
		var full_view_name=parentName+'_'+viewName;
		for(var i=0;i<len;i++) {
			if(arr_func[i].viewName==full_view_name) {
				return arr_func[i].func;
			}
		}
		return null;
	};

	nexMdi.prototype._bind=function(select_fid, key, data, value, selector_list) {
		for(var i=select_fid.length;i--;) {
			var selector = select_fid[i].selector;
			var tag_name = selector[0].tagName;
			var type = selector[0].type;
			var func = select_fid[i].func;
			var fmt = select_fid[i].fmt;
			var val=null;

			if(typeof func==='function') {
				val = func(selector, key, data, value, selector_list);
			} else 	if(fmt !== null) {
				switch(fmt) {
					case 'time' :
						if(value.length == 4)
							val = value.substring(0, 2) + ':' + value.substring(2, 4);
						else
							val = value.substring(0, 2) + ':' + value.substring(2, 4) + ':' + value.substring(4, 6);
						break;
					case 'date' :
						val = value.substring(0, 4) + '/' + value.substring(4, 6) + '/' + value.substring(6, 8);
						break;
					case 'number' : // output 값 Number 처리 후 comma
						value=Number(value);
						if(String(value).trim()=='')
							val='0';

						val=String(value).commify();
						break;
					case 'number2' :
						if(String(value).trim()=='0' || String(value).trim()=='' || Number(value) =='0' || Number(value) == '0.00' )
							val='';
						else
							val=String(value).commify();
						break;
					case 'number3' : // output 값 그대로 표시 후 comma
						if(String(value).trim()=='')
							val='0';

						val=String(value).commify();
						break;						
					case 'signNumber' :
						var gbn=value.substring(0,1);
						selector.removeClass('up low');
						//selector.removeClass('low');

						if(gbn=='+') {
							val=value.trim().substring(1);
							val='+'+val.commify();
							selector.addClass('up');
						} else if(gbn=='-') {
							val=value.trim().substring(1);
							val='-'+val.commify();
							selector.addClass('low');
						}
						break;
				}

			} else {
				val=value;
			}

			if(tag_name.toUpperCase()=='INPUT' && type !== undefined && type.toUpperCase()=='TEXT')
				selector.val(val);
			else {
				if(typeof val == 'object') {
					if(val.type !== undefined && val.type == 'html') {
						//if(selector.length==1) {
						//	selector[0].innerHTML=val.value;
						//} else {
							selector.html(val.value);
						//}
					} else {
						selector.text(val);
					}
				} else {
					selector.text(val);
				}
			}
		}
	};

	nexMdi.prototype.trBind=function(val) {
		for(var key in val.data) {
			var value=val.data[key];
			var select_fid=val.scope.info.fid[key];
			if(select_fid!==undefined) {
				this._bind(select_fid, key, val.data, value, val.scope.info);
			}
		}
	};

	nexMdi.prototype.oopTrBind=function(val) {
		for(var key in val.data) {
			if(key.length<6) {
				var cnt=6-key.length;
				for(var i=0;i<cnt;i++) {
					key='0'+String(key);
				}
			}
			var value=String(val.data[key]);
			var select_fid=val.scope.info.oop[key];
			if(select_fid!==undefined) {
				this._bind(select_fid, key, val.data, value, val.scope.info);
			}
		}
	};

	nexMdi.prototype.realBind=function(val, callback) {
		setTimeout(function(){
			var data=val.data;
			var info=val.scope.info;
			var real=info.real;
			var bind=window.nexMdi._bind;
			for(var key in data) {
				//var value=data[key];
				var select_fid=real[key];
				if(select_fid!==undefined) {
					bind(select_fid, key, data, data[key], info);
				}
			}
			if(callback !== undefined && typeof callback === 'function') callback();
		},1);

	};

	nexMdi.prototype.isTabActive=function(pName, vName){
		var tab_selector=$("#mdi" + pName).find("[role=tab]");
		for(var i = tab_selector.length; i--;) {
			if($(tab_selector[i]).hasClass("ui-tabs-active")) {
				if(vName == $(tab_selector[i]).attr("tabName") && $(tab_selector[i]).attr("tabActive")=="true") {
					return true;
				}	
			}
		}
		return false;
	};

	nexMdi.prototype.activeTabSearch=function(pName) {
		var tab_selector=$("#mdi" + pName).find("[role=tab]");
		for(var i = tab_selector.length; i--;) {
			var active=$(tab_selector[i]).attr("tabActive");
			if(typeof active=='undefined' || active==null || active.trim()=='')
				$(tab_selector[i]).attr("tabActive", "false");

			if($(tab_selector[i]).hasClass("ui-tabs-active")) {
				var vName=String($(tab_selector[i]).attr("tabName"));
				if(vName.trim()!='' ) {
					this._tabSearch(pName, vName);
					$(tab_selector[i]).attr("tabActive", "true");
				}
			}
		}
	};

	nexMdi.prototype.tabEvent=function(pName) {
		var tab_selector=$("#mdi" + pName).find("[role=tab]");
		for(var i = tab_selector.length; i--;) {
			$(tab_selector[i]).click(function() {
				var $this_selector=$(this);
				var v_name=String($this_selector.attr("tabName"));
				var v_value=$this_selector.attr("tabValue");
				var v_init=$this_selector.attr("tabInit");
				var v_load=$this_selector.attr("tabLoad");
				var v_type=$this_selector.attr("tabType");
				var v_search=$this_selector.attr("tabSearch");
				var tab_selector2=$this_selector.parent().find("[role=tab]");
				var active_tab=$this_selector.attr("tabActive");

				if(v_load == undefined || v_load == null) v_load='false';
				if(v_type == undefined || v_type == null) v_type='';
				if(v_search == undefined || v_search == null) v_search='true';
				if(v_init ==undefined || v_init==null) v_init="false";

				for(var k=tab_selector2.length;k--;) {
					var v_name2=String($(tab_selector2[k]).attr("tabName"));
					//if(v_name2!=v_name) {
					if(typeof v_name2!='undefined' && v_name2!='undefined' && v_name2.trim()!='') {
						clientSocket.pushViewOff(pName, v_name2);
						$(tab_selector2[k]).attr("tabActive", "false");
					}
					//}
				}

				if(typeof v_name!='undefined' && v_name!='undefined' && v_name.trim()!='') {
					if(active_tab === undefined || active_tab === null || active_tab == 'false') {
						window.nexMdi.tabSearch(pName, v_name, v_value, v_init, v_load, v_type, v_search);
					}
				}
				$this_selector.attr("tabActive", "true");
			});
		}
	};

	nexMdi.prototype.tabSearch=function(pName, vName, vValue, vInit, vLoad, vType, vSearch) {

		if(this.isTabActive(pName, vName))
			return;

		$("#mdi"+pName+' #stateBar_'+pName).text("");
		
		this._tabSearch(pName, vName, vValue, vInit, vLoad, vType, vSearch);
	};
	
	nexMdi.prototype._tabSearch=function(pName, vName, vValue, vInit, vLoad, vType, vSearch) {
		if(vLoad == undefined || vLoad == null) vLoad='false';
		if(vType == undefined || vType == null) vType='';
		if(vSearch == undefined || vSearch == null) vSearch='true';
		if(vInit ==undefined || vInit==null) vInit="false";

		var win_name=pName+'_'+vName, nex_mdi=window.nexMdi;
		var idx = -1;
		for(var i=0, len=nex_mdi.tabLoadCnt.length;i<len;i++) {
			if(nex_mdi.tabLoadCnt[i].winName=win_name) {
				idx=i;
				break;
			}
		}
		if(idx==-1) {
			nex_mdi.tabLoadCnt.push({winName:win_name, cnt:0});
			var len=nex_mdi.tabLoadCnt.length-1;
			for(var i=len;i--;) {
				if(nex_mdi.tabLoadCnt[i].winName==win_name) {
					idx=i;
					break;
				}
			}
		}

		if(nex_mdi._tabSearchCheckCnt>10) {
			nex_mdi._tabSearchCheckCnt=0;
			return;
		}

		if(idx==-1) {
			nex_mdi._tabSearchCheckCnt++;
			setTimeout(function(){
				nex_mdi._tabSearch(pName, vName, vValue, vInit, vLoad, vType, vSearch);
			},100);
			return;
		}

		nex_mdi._tabSearchCheckCnt=0;

		if(nex_mdi.tabLoadCnt[idx].cnt > 30) {
			nex_mdi.tabLoadCnt[idx].cnt = 0;
			return;
		}

		if(typeof vValue=='undefined' && vValue == null) {
			vValue='';
		}

		if(vLoad.toLowerCase()=='true') {
			var $Scope =nex_mdi.getCtl(pName, pName).$Scope;
			if($Scope == undefined || $Scope == null) {
				$Scope =nex_mdi.getCtl(pName, pName).$scope;
			}
			nex_mdi.ctlTabLoad({ parentName: pName, viewName: vName, scope: $Scope, type: vType, value: vValue, init:vInit, search:vSearch });
		} else {
		
			var func = nex_mdi.getCtl(pName, vName);

			if(typeof func == 'undefined' || func == null) {
				setTimeout(function() { nex_mdi._tabSearch(pName, vName, vValue, vInit); }, 100);
				nex_mdi.tabLoadCnt[idx].cnt++;
			} else {
				nex_mdi.tabLoadCnt[idx].cnt = 0;

				if(vValue!='')	func.Value=vValue;
				
				if(vInit.toLowerCase()=="true") 
					func.init(func.$Scope, func.Type, func.Value);
	
				if(vSearch.toLowerCase()=="true") 
					func.search(func.Value);
				
			}
		}
	};

	nexMdi.prototype.getRefCode=function(vName) {
		var $ref_code_selector=$("#mdi"+vName+" .search_area input[name=refCode]");
		var ref_code = $ref_code_selector.val();
		if(ref_code==undefined || ref_code.trim()=='') {
			ref_code=window.nexMdi.defaultRefCode;
			$ref_code_selector.val(ref_code);
		}
		window.nexMdi.defaultRefCode=ref_code;
		cmmUtils.setJongmokData(ref_code, vName);
		return ref_code;
	};

	nexMdi.prototype.setAllRefCode=function(refCode, viewName) {
		//nexMdi.openWins.push({ viewName:val.viewName, viewInfo:info, lockCheck: null, historyMsg:[] });
		var data=cmmUtils.getJongmokData(refCode);
		var viewNameCheck=false;
		var nex_mdi=window.nexMdi;
		if(data!=null) {
			if(typeof viewName != 'undefined' && viewName!=null && viewName.length>=4) {
				viewNameCheck=true;
				var $ref_code_selector=$("#mdi"+viewName+" .search_area input[name=refCode]");
				if($ref_code_selector.length>0) {
					$ref_code_selector.val(refCode);
					nex_mdi.getCtl(viewName).search(true);
				}
			} else {
				viewName='';
				if(!cmmUtils.configInfo.normal.marketLink) {
					var viewName=$('div.mdi-window-active').attr('viewNo').replaceAll('[','').replaceAll(']','');
				}
			}
			var open_wins=nex_mdi.openWins;
			if(open_wins.length==0) {
				nex_mdi.defaultRefCode=refCode;
				nex_mdi.open({viewName:'0101'}); //현재가 화면
			} else if(cmmUtils.configInfo.normal.marketLink){
				var lock=false;
				for(var i=0, len=open_wins.length;i<len;i++){
					if(open_wins[i].viewName==viewName && open_wins[i].lockCheck) {
						lock=true;
						break;
					}
				}
				if(!lock) {
					for(var i=0, len=open_wins.length;i<len;i++){
						if(open_wins[i].viewInfo.market.indexOf(data.gbn)>-1 && !open_wins[i].lockCheck) {
							var vName=open_wins[i].viewName;
							if(viewNameCheck && viewName==vName) {
								continue;
							}
							
							$("#mdi"+vName+" .search_area input[name=refCode]").val(refCode);
							nex_mdi.getCtl(vName).search(true);
						}
					}
				}
			} else if(!cmmUtils.configInfo.normal.marketLink && !viewNameCheck){
				for(var i=0, len=open_wins.length;i<len;i++){
					if(open_wins[i].viewInfo.market.indexOf(data.gbn)>-1) {
						var vName=open_wins[i].viewName;
						if(viewName==vName) {
							$("#mdi"+vName+" .search_area input[name=refCode]").val(refCode);
							nex_mdi.getCtl(vName).search(true);

							break;
						}
					}
				}
			}
		}
	};

	nexMdi.prototype.setEtcRefCodeEvent=function(vName, refCodeName, refNameName) {
		var $ref_code_selector=$("#mdi"+vName+" .search_area input[name="+refCodeName+"]");
		$ref_code_selector.itemAllDelX();
		for(var i=0, len=cmmUtils.stockLatelyData.length;i<len;i++) {
			$ref_code_selector.itemAddX({item1:cmmUtils.stockLatelyData[i].refName,item2:cmmUtils.stockLatelyData[i].refCode});
		}

		$ref_code_selector.off('btnClick').on('btnClick', function(){
			$(this).itemAllDelX();
			for(var i=0, len=cmmUtils.stockLatelyData.length;i<len;i++) {
				$(this).itemAddX({item1:cmmUtils.stockLatelyData[i].refName,item2:cmmUtils.stockLatelyData[i].refCode});
			}
		});

		$ref_code_selector.off('itemSelect').on('itemSelect',function(e, data){
			window.nexMdi.setRefCodeName(data.item2, vName, refCodeName, refNameName);
			$(this).trigger('change');
		});

		$ref_code_selector.off('itemDel').on('itemDel',function(e, data){
			if(data.gbn=='all') {
				$(this).itemAllDelX();
				cmmUtils.stockLatelyData=[];
				cmmUtils.stockLatelyLoad();
			} else {
				$(this).itemDelX({item1:data.item1, item2:data.item2});
				cmmUtils.stockLatelyDel(data.item2);
			}
		});

		$ref_code_selector.attr('viewName', vName);
		$ref_code_selector.keyup(function(event){
			var $this_selector=$(this);
			var ref_code=$this_selector.val().trim();
			var jongmok_data=cmmUtils.getJongmokData(ref_code);

			if(jongmok_data!=null) {
				var nm='';
				if(jongmok_data.gbn=='MINIOPTION' || jongmok_data.gbn=='OPTION') {
					nm=jongmok_data.value.ITMN;
				} else {
					nm=jongmok_data.value.KOR_ITMN;
				}

				var $ref_code_selector1=$("#mdi"+$this_selector.attr('viewName')+" .search_area input[name="+refCodeName+"]");
				var len1 =$ref_code_selector1.length;

				if( len1>=1) {
					for(var k=0;k<len1;k++) {
						$($ref_code_selector1[k]).val(ref_code);
					}
				}

				if(ref_code.length>=6 && event.keyCode!=13) {
					window.nexMdi.setRefCodeName(ref_code,vName, refCodeName, refNameName);
					if($this_selector.val()!==$this_selector.data('refCode')) {
						$this_selector.trigger('change');
					}

					$this_selector.data('refCode', $this_selector.val());
				}
			}
		});

		$ref_code_selector.focus(function(){
			var $this_selector=$(this);
			var ref_code=$this_selector.val().trim();
			if(ref_code.length>=6) {
				$this_selector[0].refCode=$this_selector.val();
				$this_selector.val('');
			}
		});

		$ref_code_selector.blur(function(){
			var $this_selector=$(this);
			var ref_code=$this_selector.val().trim();
			if(ref_code.length<6) {
				$this_selector.val($this_selector[0].refCode);
			}
		});

		$ref_code_selector.keypress(function(event){
			var $this_selector=$(this);
			if(event.keyCode==13) {
				var ref_code=$this_selector.val().trim();
				if(ref_code=='') {
					$this_selector[0].refCode='';
					$("#mdi"+vName+" .search_area input[name="+refNameName+"]").val('');
				}
				return false;
			}
		});
	};

	nexMdi.prototype.setRefCodeName=function(refCode, viewName, refCodeName, refNameName) {
		//nexMdi.openWins.push({ viewName:val.viewName, viewInfo:info, lockCheck: null, historyMsg:[] });
		if(typeof viewName != 'undefined' && viewName!=null && viewName.length>=4) {
			viewNameCheck=true;
			var $ref_code_selector=$("#mdi"+viewName+" .search_area input[name="+refCodeName+"]");
			if($ref_code_selector.length>0) {
				$ref_code_selector.val(refCode);
				cmmUtils.setJongmokData2(refCode, viewName, refCodeName, refNameName);
				//window.nexMdi.getCtl(viewName).search(); // 20160509
			}
		}
	};

	nexMdi.prototype.setRefCode=function(vName, refCode) {
		$("#mdi"+vName+" .search_area input[name=refCode]").val(refCode);
		cmmUtils.setJongmokData(refCode, vName);
	};

	nexMdi.prototype.setUpjongCode=function(upCd, upNm, vName, upjongCodeName, upjongNameName) {
		if(typeof vName != 'undefined' && vName!=null && vName.length>=4) {
			upjongCodeName = upjongCodeName || "upjongCode";
			upjongNameName = upjongNameName || "upjongName";
			var $upjong_code_selector=$("#mdi"+vName+" .search_area input[name="+upjongCodeName+"]");
			if($upjong_code_selector.length>0) {
				$upjong_code_selector.val(upCd);
				$("#mdi"+vName+" .search_area input[name="+upjongNameName+"]").val(upNm);
				window.nexMdi.getCtl(vName).search();
			}
		}
	}; 

	nexMdi.prototype.gridScroll=function(gridObj, callback) {
		$(gridObj).on("pqscrollbarscroll", function( event, ui ) {
			if(event.target.className=="pq-hscroll pq-sb-horiz pq-sb-horiz-wt") return;
			var rowData = $(gridObj).pqGrid("getRow", {rowIndxPage:1});
			var curRowNum = ui.cur_pos;
			var totRowNum = ui.num_eles;

			if(curRowNum == 0){
				if(typeof callback=='function') {
					callback('top');
				}
			}

			if(totRowNum <= curRowNum+1){
				if(typeof callback=='function') {
					callback('bottom');
				}
			}
		});
	};

    /**
     * desc : MDI창 종목연동 Lock 설정(lockCheck: false 종목연동 사용, lockCheck: true 종목연동 미사용)
     * author : 천창환
     * @param viewName : 화면 번호
     */
    nexMdi.prototype.mdiLockToggle=function(viewName) {
      if (cmmUtils.configInfo.normal.marketLink) {
		var nex_mdi_open_wins=window.nexMdi.openWins;
		var len=nex_mdi_open_wins.length;
		var $lock_btn=$("#mdi" + viewName + "_LockBtn");
		for (var i = len; i--;) {
			if (nex_mdi_open_wins[i].viewName == viewName) {
				if (nex_mdi_open_wins[i].lockCheck) {
					nex_mdi_open_wins[i].lockCheck = false;
					$lock_btn.addClass('not');
				} else {
					nex_mdi_open_wins[i].lockCheck = true;
					$lock_btn.removeClass('not');
				}
				break;
			}
		}
      } else {
        nexDialog.alert('종목 연동이 설정되어 있지 않습니다.');
      }
    };

    nexMdi.prototype.mdiAllLock=function(gbn) {
		var nex_mdi_open_wins=window.nexMdi.openWins;
		var len=nex_mdi_open_wins.length;
		for (var i = len; i--;) {
			var $lock_btn=$("#mdi" + nex_mdi_open_wins[i].viewName + "_LockBtn");
			nex_mdi_open_wins[i].lockCheck = !gbn;
			if (!gbn) {
				$lock_btn.removeClass('not');
			} else {
				$lock_btn.addClass('not');
			}
		}
    };

	nexMdi.prototype.dataMapper=function(data1, data2) {
		if(data1 === undefined || data2 === undefined || data1 === null || data2 === null) {
			return;
		}

		if(data1.length !== undefined) {
			var rtn_data=[];
			var len1=data1.length;
			for(var i=0;i<len1;i++) {
				var row_data=[];
				var len2=data2.length;
				for(var k=0;k<len2;k++){
					//for(var key in data1[i]) {
						//if(data2[k]==key) {
							//row_data.push(data1[i][key]);
							//break;
						//}
					//}
					row_data.push(data1[i][data2[k]]);
				}
				rtn_data.push(row_data.slice());
			}
			return rtn_data;
		} else {
			var row_data=[];
			var len2=data2.length;
			for(var k=0;k<len2;k++){
				/*
				for(var key in data1) {
					if(data2[k]==key) {
						row_data.push(data1[key]);
						break;
					}
				}
				*/
				row_data.push(data1[data2[k]]);
			}
			return row_data;
		}
	};

	// 화면상의 모든 input TAG disabled
	nexMdi.prototype.disableInput=function(vName,tabId) {
		var $mdi_selector=$("#mdi"+vName);
		var disabledInput = $mdi_selector.find("input:disabled,button:disabled,select:disabled");
		var len=disabledInput.length;
		for(var i=0;i<len;i++){
			$(disabledInput[i]).addClass("blocked");
		}
		
		disabledInput = $mdi_selector.find(".datepicker");
		len=disabledInput.length;
		for(var i=0;i<len;i++){
			$(disabledInput[i]).addClass("blocked");
		}
		
		if(tabId===undefined || tabId == ''){
			$mdi_selector.find("input, button").each(function(){
				// blocked는 제외
				var $this_selector=$(this);
				if( !$this_selector.hasClass("blocked") ){
					$this_selector.attr("disabled","disabled");
				}
			});
		} else {
			$mdi_selector.find('#'+tabId).find("input, button, select").each(function(){
				// blocked는 제외
				var $this_selector=$(this);
				if( !$this_selector.hasClass("blocked") ){
					$this_selector.attr("disabled","disabled");
				}
			});
		}
		
	};

	// 화면상의 모든 input TAG disabled 제거
	nexMdi.prototype.enableInput=function(vName,tabId){
		var $mdi_selector=$("#mdi"+vName);
		if(tabId===undefined || tabId == ''){
			$mdi_selector.find("input, button, select").each(function(){
				// blocked는 제외
				var $this_selector=$(this);
				if( !$this_selector.hasClass("blocked") ){
					$this_selector.removeAttr("disabled");
				}
			});
		} else {
			$mdi_selector.find('#'+tabId).find("input, button, select").each(function(){
				// blocked는 제외
				var $this_selector=$(this);
				if( !$this_selector.hasClass("blocked") ){
					$this_selector.removeAttr("disabled");
				}
			});
		}
	};
	
	//선물옵션 종목 선택
	nexMdi.prototype.setAllFnoCode=function(fnoCode, viewName) {
		var data=cmmUtils.getJongmokData(fnoCode);
		var viewNameCheck=false;
		var nex_mdi=window.nexMdi;
		if(data!=null) {
			if(typeof viewName != 'undefined' && viewName!=null && viewName.length>=4) {
				viewNameCheck=true;
				var $fno_code_selector1=$("#mdi"+viewName+" .search_area input[name=fnoCode1]");
				if($fno_code_selector1.length>0) {
					$fno_code_selector1.val(fnoCode.substring(0,fnoCode.length - 3));
					$("#mdi"+viewName+" .search_area input[name=fnoCode2]").val(fnoCode.substring(fnoCode.length - 3));
					nex_mdi.getCtl(viewName).search();
				}
			} else {
				viewName='';
			}
			var open_wins=nex_mdi.openWins;
			if(open_wins.length==0) {
				nex_mdi.defaultFnoCode=fnoCode;
				nex_mdi.open({viewName:'0301'}); //선물옵션현재가 화면
			} else {
				var len=open_wins.length;
				for(var i=0;i<len;i++){
					if(open_wins[i].viewInfo.market.indexOf(data.gbn)>-1 && !open_wins[i].lockCheck) {
						var vName=open_wins[i].viewName;
						if(viewNameCheck && viewName==vName) {
							continue;
						}
						
						$("#mdi"+vName+" .search_area input[name=fnoCode1]").val(fnoCode.substring(0,fnoCode.length - 3));
						$("#mdi"+vName+" .search_area input[name=fnoCode2]").val(fnoCode.substring(fnoCode.length - 3));
						nex_mdi.getCtl(vName).search();
					}
				}
			}
		}
	};

	//  선물옵션 종목 가져오기
	nexMdi.prototype.getFnoCode=function(vName) {
		var fno_code = $("#mdi"+vName+" .search_area input[name=fnoCode1]").val()
			         + $("#mdi"+vName+" .search_area input[name=fnoCode2]").val();
		if(fno_code==undefined || fno_code.trim()=='') {
			//fno_code=MasterCode.FUTURE[0].ITM_CD;
			if (cmmUtils.fnoLatelyData.length == 0) {
				fno_code=MasterCode.FUTURE[0].ITM_CD;
			} else {
				fno_code=cmmUtils.fnoLatelyData[0].fnoCode;
			}
			$("#mdi"+vName+" .search_area input[name=fnoCode1]").val(fno_code.substring(0,fno_code.length - 3));
			$("#mdi"+vName+" .search_area input[name=fnoCode2]").val(fno_code.substring(fno_code.length - 3));
		}
		cmmUtils.setFnoData(fno_code, vName);
			
		return fno_code;
	};

	window.nexMdi = new nexMdi();
})(window, jQuery)