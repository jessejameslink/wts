(function(window, $, undefined) {
	function nexClient() {	
		var socket = null;
		var helloTimeout;
		var self=this;
		var mainFrame=null;
		var packetList=[];
		var packetListData=[];
		var rtsCallbacks=[];
		
		this.socketConnection=false;
		this.reConnectCount=0;
		this.loginCheck=false;
		this.loginTimeout=null;
		this.disconnectType='';
		this.viewXyList=[];
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// node Client
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		serverUrl	=	window.RTS_IP;
		
		this.webSocketConnect = function(serverUrl) {
			/*
			console.log("************WEB SOCKET CONNECT************");
			console.log(serverUrl);
			console.log("******************************************");
			*/
			mainFrame=window;
			mainFrame.LOGIN_ID = "077" + mainFrame.LOGIN_ID
			if(typeof serverUrl=='undefined' || serverUrl==null || serverUrl=='') {
				//serverUrl="http://172.21.21.182:8000";
				//serverUrl="https://rtstest.smartmiraeasset.com:443";
				//serverUrl="http://10.0.31.9:8080";
				//serverUrl="http://10.0.31.3:8001";
				serverUrl="http://10.0.31.27:8080";
				//serverUrl="https://rts3.smartmiraeasset.com";
			}
			/*
			console.log("$$$$$$$$$$$$$$$$$$SERVER URL CHECK=?2");
			console.log(serverUrl);
			console.log("###########################################");
			*/
			self = this;
			socket = io.connect(serverUrl, {
				'reconnect': false,
				'sync disconnect on unload': false,
				'force new connection': true
			});

			socket.on('connect', function() {
				self.socketConnection = true;				
				self.disconnectType='';
				// for testing --------------------
				if(mainFrame.LOGIN_ID == '') {
					mainFrame.LOGIN_ID='logintest';
				}
				//mainFrame.LOGIN_ID='logintest';
				//mainFrame.LOGIN_ID='077C080169';
				// --------------------------------
				setTimeout(function(){
					if(socket!=null) {

						//�α��� ���� ������ ���� �õ�
						//alert("CHECK LOGIN ID==>" + mainFrame.LOGIN_ID);
						if(mainFrame.LOGIN_ID.trim()!='') {
							socket.emit('mbrLogin', mainFrame.LOGIN_ID.trim());
							self.loginTimeout=setTimeout(function(){
								if(!self.loginCheck && self.socketConnection) {
									socket.emit('mbrLogin', mainFrame.LOGIN_ID.trim());
								}
							},2000);
						} else {
							//console.log("5");
							mainFrame.nexDialog.alert('세션이 종료 되었습니다. 메인 홈페이지로 이동합니다.\n\n다시 로그인하여 주세요.');
							try{
								if(parent) parent.goMain();
							}catch(e){
								;
							}
						}
					}
				},200);
			});

			//RTS 접속중에 연결이 끈어졌을 경우
			socket.on('rtsServerError', function() {
				self.disconnectType='rtsError';
				self.webSocketDisconnect();
			});

			//MCA 서버 모두 다운됐을 경우
			socket.on('rtsAllOffline', function() {
				self.disconnectType='rtsAllOffline';
				self.webSocketDisconnect();
			});

			socket.on('disconnect', function() {
				clearTimeout(helloTimeout);
				packetList=[];
				packetListData=[];
				rtsCallbacks=[];
				self.viewXyList=[];
				self.loginCheck=false;
				self.socketConnection = false;

				if(typeof mainFrame!='undefined' && mainFrame != null) {
					try {
						//연결 끊겼을때 화면 Action
						mainFrame.cmmUtils.wtsOnOff('off');							
					} catch(e) {
						;
					}
				}

				try {
					socket.disconnect();
				} catch(e) {
					;
				} finally {
					socket = null;	
				}
			});

			socket.on('LOGID', function(data) {
				
			});

			socket.on('login', function(data) {
				clearTimeout(self.loginTimeout);
				if(data=='OK')
					self.loginCheck=true;
			});

			socket.on('MSGID', function(data) {
				// node ���������� node Ŀ�ؼ� ���� ó�� ����
				clearTimeout(helloTimeout);					

				if (data == 'RTMREADY')	{
					if(typeof socket != 'undefined' && socket != null) {
						socket.emit('hello', 'push1');
						//socket.json.send({command:'hello', data:'push1'});
						self.socketConnection = true;
						self.reConnectCount = 0;
					}
				}
			});
	////////////////////////////////////////////////////////////////////////////////

			socket.on('mbrLoginRep', function(data) {
				var procRet = data.substr(0,1);
				// if (procRet != '1')	alert('mbrLoginRep LOGIN FAILURE.');
				var loginRepEnc = data.substr(2);
				if (loginRepEnc.length > 0)	{
					var loginRep = unetDecryptFlash(loginRepEnc);
				}
				self.reConnectCount = 0;
			});

	//////////////////////////////////////////////////////////////////////////////// �ǽð� ������
			
			socket.on('tr', function(data){
				//console.log('tr')
				//console.log(data)
				//setTimeout(function(){self.sendTrData(data);},0);
				self.sendTrData(data);
			});

			socket.on('push', function(data){
				//setTimeout(function(){self.sendData(data);},0);
				self.sendData(data);
			});

	////////////////////////////////////////////////////////////////////////////////
		};

		this.webSocketDisconnect = function() {
			//console.log('disconnect')
			packetList=[];
			packetListData=[];
			rtsCallbacks=[];
			self.viewXyList=[];
			self.loginCheck=false;
			self.socketConnection=false;

			try{
				socket.disconnect();
			}catch (e) {
				;
			} finally {
				socket = null;	
			}
		};
		
		
		/*
		 * 실시간 데이터 받는 부분.
		 * 실시간 호출에 등록한 펑션 호출
		 * */
		this.sendData=function(data) {
			//console.log('sendData');
			//console.log(data);
			//console.log(rtsCallbacks)
			for(var i = rtsCallbacks.length; i--;) {
				var gubuns=rtsCallbacks[i].GUBUNS;
				if(typeof gubuns !='undefined') {
					var idx=gubuns.indexOf(data.gubn);
					//console.log("IDX type==>" + typeof(idx));
					//console.log("gubuns=>" + gubuns + ", datagubun=>" + data.gubn + ", index=>" + idx);
					if(idx>-1) {
						//console.log("VALUE=>" + rtsCallbacks[i].VALUES + ", DATA CODE=>" + data.code);
						if(rtsCallbacks[i].VALUES.indexOf(data.code)>-1);
							//console.log("-----func name==>" + rtsCallbacks[i].REAL[idx]);
							//console.log("CALL DATA");
							rtsCallbacks[i].REAL[idx](data);
					}
				}
			}
		};

		this.sendTrData=function(data) {
			//console.log('sendTrData')
			//console.log(packetListData)
			var value='';
			var idx=packetList.indexOf(data.xwin+'_'+data.ywin);
			if(idx>-1) {
				var value_idx=-1;
				var svcc=data.svcc+'_';
				for(var i=0, len=packetListData[idx].WINS.length;i<len;i++)	{
					try{
						if(packetListData[idx].WINS[i].ID.indexOf(svcc)>-1) {
							packetListData[idx].WINS[i].OBJECT(data);
						}
					}
					catch (e) {;}
				}
			}
		};
		
		
		//실시간 호출 펑션 등록
		this.rtsReg=function(options){
			
//console.log("실시가 놓추 ㄹ펑션 call");
//console.log(options);
//console.log("=======================");

			
			var obj=[];
			for(var k=0;k<options.GUBUNS.length;k++) {
				var obj2=eval('realData_'+String(options.GUBUNS[k]));
				if(obj2) {
					obj.push(obj2);
				}
			}
			var data={NAME:'test', REAL:obj, GUBUNS:options.GUBUNS, VALUES:options.VALUES};
			rtsCallbacks.push(data);
		};

		

		this.rtsDel=function(parentName, viewName) {

			if(typeof viewName =='undefined' || viewName==null || viewName=='') {

				viewName=parentName;

			}



			var win_name=parentName+'_';

			if(parentName!=viewName)

				win_name+=viewName;



			var callbacks=rtsCallbacks.slice(0);

			for(var i=(rtsCallbacks.length-1);i>=0;i--) {

				if(callbacks[i].NAME.indexOf(win_name)>-1) {

					callbacks.splice(i, 1);

				}

			}

			rtsCallbacks=callbacks;

		};



		//데이터 받을 타겟팅 설정
		this.viewXyWin=function(pName, vName, key, keys, symbols, gridKey) {
			/*
			console.log("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
			console.log("pName=>" + pName +", vName=>" + vName);
			console.log("key=>" + key +", keys=>" + keys);
			console.log("symbols=>" + symbols +", gridKey=>" + gridKey);
			console.log("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
			*/
			
			var y=0;
			var name=pName+'_'+vName;
			if(typeof gridKey == 'undefined' || gridKey==null || gridKey=='') {
				gridKey='000000';
			}

			if(typeof symbols == 'undefined' || symbols==null || symbols=='') {
				symbols=['000000'];
			}

			
			var symbolsText='S'+String(key)+keys.join('')+String(gridKey)+symbols.join('');
			
			var idx1=-1;
			var idx2=-1;

			for(var i=0;i<this.viewXyList.length;i++) {
				if(this.viewXyList[i].NAME.indexOf(pName+'_')>-1 ) {
					for(var k=0;k<this.viewXyList[i].symbolsText.length;k++) {
						if(symbolsText==this.viewXyList[i].symbolsText[k] ) {
							idx2=k;
							break;
						}
					}
					idx1=i;
					break;
				}
			}

			if(idx2>-1 && typeof this.viewXyList[i].Y[idx2]=='undefined') {
				idx2=-1;
			}

			if(idx1>-1 && idx2>-1) { //x, y 값이 있을경우
				return {x:this.viewXyList[idx1].X, y:this.viewXyList[i].Y[idx2]};
			} else if(idx1>-1) { //x 값만 있을경우
				y=this.viewXyList[idx1].Y[this.viewXyList[idx1].Y.length-1]+1;
				this.viewXyList[idx1].Y.push(y);
				this.viewXyList[idx1].symbolsText.push(symbolsText);
				return {x:this.viewXyList[idx1].X, y:y};
			} else { // 신규 요청
				var xx='';
				var x=['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
					'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
					'!','@','#','$','%','&','*','(',')','-','+','|','.',',','/','?','=','<','>','[',']','{','}'];
				for(var i=0;i<x.length;i++) {
					var chk=false;
					for(var j=0;j<this.viewXyList.length;j++) {
						if(x[i]==this.viewXyList[j].X) {
							chk=true;
							break;
						}
					}

					if(!chk) {
						xx=x[i];
						break;
					}
				}

				var arrY=[];
				arrY.push(y);
				var arrSymbolsText=[];
				arrSymbolsText.push(symbolsText);				
				this.viewXyList.push({NAME:name, X:xx, Y:arrY, symbolsText:arrSymbolsText});
				return {x:xx, y:y};
			}
		};



		//현물
		this.pushStokOn=function(options) {
			options.reqGbn='stok';
			this.pushOn(options);
		};
		
		//뉴스
		// {value:종목코드, date:날짜, dirf:'X/N', gubn:'111111111111111', subg:중분류 1*450, desc:검색키워드, vend:reqData.vend, seqn:reqData.seqn};
		this.pushNewsOn=function(options) {
			options.reqGbn='news';
			this.pushOn(options);
		};
		
		this.pushCurrOn=function(options) {
			options.reqGbn='curr';
			this.pushOn(options);
		};

		this.pushTprcOn=function(options) {
			options.reqGbn='tprc';
			this.pushOn(options);
		};
		
		this.pushTprcOn=function(options) {
			options.reqGbn='tpup';
			this.pushOn(options);
		};

		this.pushMystOn=function(options) {
			options.reqGbn='myst';
			this.pushOn(options);
		};
		
		this.pushIndxOn=function(options) {
			options.reqGbn='indx';
			this.pushOn(options);
		};

		this.pushOn=function(options) {
			setTimeout(function(){
				var symbols=[];
				if(typeof options.symbols!='undefined') {
					symbols=options.symbols;
				}

				if(options.keys === undefined) {
					options.keys=[];
				}

				//console.log("+++++++++++++++++++++++++++++++++++++++++++++++++");
				//console.log("222CHK pname==>" + String(options.pName) + ", vname=>" + String(options.vName));
				//console.log("+++++++++++++++++++++++++++++++++++++++++++++++++");

				var xy=self.viewXyWin(String(options.pName), String(options.vName), options.key, options.keys, symbols, options.gKey);
//				console.log('xy = ')
//				console.log(xy)
				if(typeof options.reqGbn=='undefined') {
					options.reqGbn='stok';
				}

				var svcc=String(options.pName);								
				//rts 서버로 보내는 최종 데이터 포맷
				var data={reqGbn:options.reqGbn, svcc:String(svcc), xWin:xy.x, yWin:xy.y, 
					pName:String(options.pName), vName:String('MAS'), 
					key:options.key, keys:options.keys, value:options.value ,values:options.values, date:options.date, symbols:options.symbols, symbols1:options.symbols1, symbols2:options.symbols2, 
					gKey:options.gKey, rows:options.rows, dirf:options.dirf, gubn:options.gubn, subg:options.subg, desc:options.desc, vend:options.vend, 	
					seqn:options.seqn, indx:options.indx, igap:options.igap, iKey:options.iKey, page:options.page, save:options.save
					,symb:options.symb, lang:options.lang, usid:options.usid, grpn:options.grpn
				};
				self._pushOnSend(data, options.receive);
			},1);
		};



		this._pushOnSend=function(data, receive) {
			//console.log("PUSH ON SEND~~~~~~~~~~");
			if(self.socketConnection) {
				//console.log("CONNECTION CALL");
				if(typeof data.value=='undefined' || data.value==null) {
					data.value='';
				}
				var xWinyWin=data.xWin+'_'+data.yWin;
				var win_name=data.pName+'_'+data.vName;
				var idx=packetList.indexOf(xWinyWin);

				//console.log("####PACKET LIST####");
				//console.log(packetList);
				//console.log("####WIN CHECK######");
				//console.log(xWinyWin);
				//console.log("INDEX CHECK===>" + idx);
				//console.log(win_name);

				if(idx>-1) {
					var win_check=false;
					var win_idx=-1;
					var value_check=false;
					for(var i=0;i<packetListData[idx].WINS.length;i++)	{
						if(packetListData[idx].WINS[i].ID==win_name) {
							win_check=true;
							win_idx=i;
						}

						var value_idx=packetListData[idx].WINS[i].VALUE.indexOf(data.value.trim());
						if(value_idx>-1)	{
							value_check=true;
						}
					}
					//console.log("CHECK WIN==>" + win_check);
					if(!win_check) {
						var obj=[];
						//console.log("CHK PANME=>" + data.pName + ", VNAME=>" + data.vName);
						var ctl=mainFrame.nexMdi.getCtl(data.pName, data.vName);
						if(typeof receive =='function'){
							packetListData[idx].WINS.push({ID:win_name, REQGBN:data.reqGbn, VALUE:[],OBJECT:receive, REAL:obj});
						} else {
							packetListData[idx].WINS.push({ID:win_name, REQGBN:data.reqGbn, VALUE:[],OBJECT:null, REAL:obj});
						}
						packetListData[idx].WINS[packetListData[idx].WINS.length-1].VALUE.push(data.value.trim());
					} else {
						var value_idx=packetListData[idx].WINS[win_idx].VALUE.indexOf(data.value.trim());
						if(value_idx<0) {
							packetListData[idx].WINS[win_idx].VALUE.push(data.value.trim());
						}
					}
					if(typeof socket != 'undefined' && socket != null) {
						//console.log("$$SOCKET EMIT CALL");
						socket.emit('pushON',data);
					}
						//신규 PACKETlIST일 경우
				} else {
					//console.log("신규 패킷~~~~~~~~~~~~");
					packetList.push(xWinyWin);
					packetListData.push({WINS:[]});
					var obj=[];
					if(typeof receive =='function'){
						packetListData[packetListData.length-1].WINS.push({ID:win_name, REQGBN:data.reqGbn, VALUE:[],OBJECT:receive, REAL:obj});
					} else {
						packetListData[packetListData.length-1].WINS.push({ID:win_name, REQGBN:data.reqGbn, VALUE:[],OBJECT:null ,REAL:obj});
					}
					packetListData[packetListData.length-1].WINS[packetListData[packetListData.length-1].WINS.length-1].VALUE.push(data.value.trim());
					/*
					console.log('packetListData = ')
					console.log(packetListData)
					console.log('packetList = ')
					console.log(packetList)
					*/
					if(typeof socket != 'undefined' && socket != null) {
						socket.emit('pushON',data);
					}
				}
			} else {
				//console.log("***NOT CONNECTED==>" + window.RTS_IP);
				//nexClient.webSocketConnect(window.RTS_IP);
			}
		};


		
		/////////////////////////////////////////////////////////////// 이하 연결 삭제 관련  /////////////////////////////////////////////////////////////// 
		// 실시간 삭제(전체)
		this.pushAllOff=function() {
			setTimeout(function() {
				for(var k=0;k<packetList.length;k++) {
					for(var i=0;i<packetListData[k].WINS.length;i++) {
						var arr_name=packetListData[k].WINS[i].ID.split('_');
						var reqGbn=packetListData[k].WINS[i].REQGBN;
						
						/*
						var arr_value;
						if($.isArray(packetListData[k].WINS[i].VALUE)) {
							arr_value=packetListData[k].WINS[i].VALUE.slice(0);
						} else {
							arr_value=packetListData[k].WINS[i].VALUE;
						}
						*/
						var win=packetList[k].split('_');
						self.pushOff({reqGbn:reqGbn, xWin:win[0], yWin:win[1], pName:arr_name[0], vName:arr_name[1]});
					}
				}
			},50);
		};



		// 실시간 삭제(View 화면에 연결된 실시간만)
		this.pushViewOff=function(parentName, viewName) {
			if(typeof viewName =='undefined' || viewName==null || viewName=='') {
				viewName=parentName;
			}
			this.rtsDel(parentName, viewName);
			//console.log(parentName)
			//console.log(viewName)
			if(parentName==viewName) {
				for(var k=0;k<packetList.length;k++) {
					for(var i=0;i<packetListData[k].WINS.length;i++) {
						if(packetListData[k].WINS[i].ID.indexOf(parentName+'_')>-1) {
							var arr_name=packetListData[k].WINS[i].ID.split('_');
							var reqGbn=packetListData[k].WINS[i].REQGBN;
							var win=packetList[k].split('_');
							self.pushOff({reqGbn:reqGbn, xWin:win[0], yWin:win[1], pName:parentName, vName:arr_name[1]});
						}
					}
				}
			} else {
				//console.log(packetListData)
				var chk=false;
				var win_name=parentName+'_'+viewName;
				for(var k=0;k<packetListData.length;k++) {
					for(var i=0;i<packetListData[k].WINS.length;i++) {
						if(packetListData[k].WINS[i].ID==win_name) {
							chk = true;
							var win=packetList[k].split('_');
							var reqGbn=packetListData[k].WINS[i].REQGBN;
							self.pushOff({reqGbn:reqGbn, xWin:win[0], yWin:win[1], pName:parentName, vName:viewName});
							break;
						}
					}
					if(chk) {
						break;
					}
				}
			}
		};



		// 실시간 삭제(공통, 배열 구분)
		this.pushOff=function(options) {
			setTimeout(function() {
				self._pushOffSend(options.reqGbn,options.xWin, options.yWin, String(options.pName), String(options.vName));
			},1);
		};

		// 실시간 삭제 처리
		this._pushOffSend=function(reqGbn, xWin, yWin, parentName, viewName) {
			if(self.socketConnection) {
				var win_name=parentName+'_'+viewName;
				var idx=packetList.indexOf(xWin+'_'+yWin);
				if(idx>-1) {
					var win_check=false,i=0;
					for(;i<packetListData[idx].WINS.length;i++) {
						if(packetListData[idx].WINS[i].ID==win_name) {
							win_check=true;
							break;
						}
					}

					if(win_check) {
						if(packetListData[idx].WINS.length>0) {
							packetListData[idx].WINS.splice(i, 1);
							if(packetListData[idx].WINS.length==0)	{
								packetList.splice(idx, 1);
								packetListData.splice(idx, 1);
							}
							var yWin_number=Number(yWin);
							for(var i=0;i<this.viewXyList.length;i++) {
								if(this.viewXyList[i].NAME==win_name) {
									var yWin_idx=this.viewXyList[i].Y.indexOf(yWin_number);
									if(yWin_idx>-1) {
										this.viewXyList[i].Y.splice(yWin_idx, 1);
									}
									if(this.viewXyList[i].Y.length==0) {
										this.viewXyList.splice(i, 1);
									}
								}
							}

							if(typeof socket != 'undefined' && socket != null) {
								var svcc=String(parentName);
								if(svcc.length>4) {
									var start_str=svcc.length-4;
									svcc=svcc.substring(start_str, svcc.length);
								}
								//console.log('삭제')
								//console.log({reqGbn:reqGbn, svcc:String(svcc), xWin:xWin, yWin:yWin})
								socket.emit('pushOFF',{reqGbn:reqGbn, svcc:String(svcc), xWin:xWin, yWin:yWin});
							}
						}
					}
				}
			}
		};
	}
	window.nexClient = new nexClient();
})(window, jQuery)
