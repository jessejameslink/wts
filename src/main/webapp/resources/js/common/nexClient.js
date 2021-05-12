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
		
		this.makeLPack = function(str, size, packStr) {
			var len = str.length;
			var pkt_str1 = packStr.substr(0,1);
		
			if (len < size) {
				var s = "";
				for (var i = 0; i < size - len; i++) s += pkt_str1;
				return s + str;
			} else {
				return str.substr(len - size);
			}
		};
		
		this.makeRPack = function(str, size, packStr) {
			var len = str.length;
			var pkt_str1 = packStr.substr(0,1);
		
			if (len < size)	{
				var s = "";
				for (var i = 0; i < size - len; i++) s += pkt_str1;
				return str + s;
			} else {
				return str.substr(0, size);
			}
		};
		
		this.pad2 = function(s) {
			if      (s.length < 2) return "0" + s;
			else                   return s;
		};
		
		this.pad3 = function(s) {
			if      (s.length < 2) return "00" + s;
			else if (s.length < 3) return "0" + s;
			else                   return s;
		};
		
		this.pad4 = function(s)	{
			if      (s.length < 2) return "000" + s;
			else if (s.length < 3) return "00" + s;
			else if (s.length < 4) return "0" + s;
			else                   return s;
		};
		
		this.isMobile = function() {
			var bool;
			var ua=navigator.userAgent;
			if(
				ua.match(/iPhone|iPod|iPad|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson/i)!=null ||
				ua.match(/LG|SAMSUNG|Samsung/)!=null
			){
				bool=true;
			}else{
				bool=false;
			};
			return bool;
		};
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// node Client
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
		this.webSocketConnect = function(serverUrl) {

			//var serverUrl = '';
			/*
			var content=parent.document.getElementsByName('fbody')[0];
			if(typeof content != 'undefined' && content != null) {
				mainFrame=content.contentWindow.window;
			} else {
				mainFrame=parent.window;
			}
			*/
			mainFrame=window;
			
			if(typeof serverUrl=='undefined' || serverUrl==null || serverUrl=='') {
				serverUrl="http://172.21.21.182:8000";
			}

			self = this;
			//'secure': true,
			socket = io.connect(serverUrl, {
				
				'reconnect': false,
				'sync disconnect on unload': false,
				'force new connection': true
			});

			socket.on('connect', function() {
				self.socketConnection = true;
				setTimeout(function(){
					if(mainFrame.LOGIN_ID.trim()!='') {
						socket.emit('mbrLogin', mainFrame.LOGIN_ID.trim());
						self.loginTimeout=setTimeout(function(){
							if(!self.loginCheck && self.socketConnection) {
								socket.emit('mbrLogin', mainFrame.LOGIN_ID.trim());
							}
						},2000);
					} else {
						mainFrame.nexDialog.alert('세션이 종료 되었습니다. 메인 홈페이지로 이동합니다.\n\n다시 로그인하여 주세요.');
						try{
							if(parent) parent.goMain();
						}catch(e){
							;
						}
					}
				},200);
				
				// node 연결지연시 node 커넥션 끊기(30s)
				//helloTimeout = setTimeout(function() {
				//	self.webSocketDisconnect();
				//}, 30000);
			});
			
			
			//MCA 접속중에 연결이 끈어졌을 경우
			socket.on('siseServerError', function() {
				if(typeof mainFrame!='undefined' && mainFrame != null) {
					try {
						//mainFrame.socketConnectionOnOff(false);
						//mainFrame.mcaConnectionError('mdi');
					} catch(e) {
						;
					}
				}
			});
			
			//MCA 서버 모두 다운됐을 경우
			socket.on('siseAllOffline', function() {
				self.webSocketDisconnect();
				if(typeof mainFrame!='undefined' && mainFrame != null) {
					try {
						//mainFrame.socketConnectionOnOff(false);
						//mainFrame.mcaAllConnectionError('mdi');
					} catch(e) {
						;
					}
				}
			});

			socket.on('disconnect', function() {
				clearTimeout(helloTimeout);
				packetList=[];
				packetListData=[];
				self.socketConnection = false;
				
				if(typeof mainFrame!='undefined' && mainFrame != null) {
					try {
						//mainFrame.socketConnectionOnOff(false);
						//mainFrame.siseServerDownError('mdi');	
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
				
				// node 연결지연시 node 커넥션 끊는 처리 제거
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
	//////////////////////////////////////////////////////////////////////////////// 실시간 데이터
			socket.on('tr', function(data){
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
			packetList=[];
			packetListData=[];
			self.socketConnection=false;
		
			try{
				socket.disconnect();
			}catch (e) {
				;
			} finally {
				socket = null;	
			}
		};
		
		this.memberLoginProcCheck = false;
		this.memberLoginProc = function() {
			
			if(self.memberLoginProcCheck) return;
			
			self.memberLoginProcCheck=true;
			

				
			//$.ajaxSend({url:'/wts/userInfo.do', callback:self.resuntMemberLoginProc});
		};
		
		this.resuntMemberLoginProc=function(data) {
	  
		};
		this.sendTrData=function(data) {
			var value='';
			
			var idx=packetList.indexOf(data.xwin+'_'+data.ywin);
			if(idx>-1) {
				var value_idx=-1;
				
				for(var i=0;i<packetListData[idx].WINS.length;i++)	{
					try{
						if(packetListData[idx].WINS[i].ID.indexOf(data.svcc+'_')>-1) {
							packetListData[idx].WINS[i].OBJECT(data);
						}
					}
					catch (e) {;}
				}
			}
		};

		this.sendData=function(data) {
			for(var i = rtsCallbacks.length; i--;) {
				if(typeof rtsCallbacks[i].GUBUNS !='undefined') {
					var idx=rtsCallbacks[i].GUBUNS.indexOf(data.gubn);
					if(idx>-1) {
						if(rtsCallbacks[i].VALUES.indexOf(data.code)>-1)
							rtsCallbacks[i].REAL[idx](data);
					}
				}
			}
			//console.log(data.gubn);
		};

		this.rePushOn=function() {
			for(var i=0;i<packetList.length;i++) {
				for(var k=0;k<packetListData[i].WINS.length;k++) {
					var arr_view=packetListData[i].WINS[k].ID.split('_');
					var value=null;
					if(packetListData[i].WINS[k].VALUE.length>0) {
						value=packetListData[i].WINS[k].VALUE;
					} else {
						value='';
					}
					
					self.pushOn(packetList[i],arr_view[0],arr_view[1],value);
				}
			}
		};

		this.rtsReg=function(options) {
			var idx=-1;
			var win_name=String(options.pName)+'_'+String(options.vName);			 
			for(var i=0;i<rtsCallbacks.length;i++) {
				if(rtsCallbacks[i].NAME==win_name) {
					idx=i;
					break;
				}
			}

			if(idx==-1){
				var obj=[];
				var ctl=mainFrame.nexMdi.getCtl(String(options.pName), String(options.vName));
				if(typeof ctl == 'undefined' || ctl == null) {
					ctl=mainFrame.nexDialog.getCtl(String(options.vName));
				}

				if(typeof options.GUBUNS != 'undefined') {
					for(var k=0;k<options.GUBUNS.length;k++) {
						var obj2=eval('ctl.realData_'+String(options.GUBUNS[k]));
						if(obj2) {
							obj.push(obj2);
						}
					}
				}
				var data={NAME:win_name, REAL:obj, GUBUNS:options.GUBUNS, VALUES:options.VALUES};
				rtsCallbacks.push(data);
			} else {
				rtsCallbacks[idx].VALUES=options.VALUES;
			}
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

//{svcc:'ȭ���ȣ',xwin:'A~Z',ywin:'1~99',symbols:[],gubuns:[],key:'',code:''}
		
		this.viewXyList=[];
		this.viewXyWin=function(pName, vName, key, symbols, gridKey) {

			var y=0;
			var name=pName+'_'+vName;

			if(typeof gridKey == 'undefined' || gridKey==null || gridKey=='') {
				gridKey='000000';
			}

			if(typeof symbols == 'undefined' || symbols==null || symbols=='') {
				symbols=['000000'];
			}

			var symbolsText='S'+String(key)+String(gridKey)+symbols.join('');

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

		//현물그래프
		//{key:reqData.key, value:reqData.value, gKey:reqData.graphKey, rows:reqData.rows, date:reqData.date, indx:reqData.indx, igap:reqData.igap, page:reqData.page, save:reqData.save, reqData.symbols1, reqData.symbols2}
		this.pushGraphStokOn=function(options) {
			options.reqGbn='gstok';
			this.pushOn(options);
		};

		//지수
		this.pushIndxOn=function(options) {
			options.reqGbn='indx';
			this.pushOn(options);
		};

		//선물
		this.pushFoptOn=function(options) {
			options.reqGbn='fopt';
			this.pushOn(options);
		};

		//선물그래프
		this.pushGraphFoptOn=function(options) {
			options.reqGbn='gfopt';
			this.pushOn(options);
		};

		//관심종목
		//values,symbols 존재 
		this.pushInterestOn=function(options) {
			options.reqGbn='interest';
			this.pushOn(options);
		};
		//뉴스
		// {value:종목코드, date:날짜, dirf:'X/N', gubn:'111111111111111', subg:중분류 1*450, desc:검색키워드, vend:reqData.vend, seqn:reqData.seqn};
		this.pushNewsOn=function(options) {
			options.reqGbn='news';
			this.pushOn(options);
		};


		this.pushOn=function(options) {
			setTimeout(function(){
				var symbols=[];
				if(typeof options.symbols!='undefined') {
					symbols=options.symbols;
				} else if(typeof options.symbols1!='undefined')	{
					symbols=options.symbols1;
				} else if(typeof options.symbols2!='undefined')	{
					symbols=options.symbols2;
				}

				var xy=self.viewXyWin(String(options.pName), String(options.vName), options.key, symbols, options.gKey);
				
				if(typeof options.reqGbn=='undefined') {
					options.reqGbn='stok';
				}
				
				var data={reqGbn:options.reqGbn, svcc:String(options.pName), xWin:xy.x, yWin:xy.y, 
							pName:String(options.pName), vName:String(options.vName), 
							key:options.key, value:options.value ,values:options.values, date:options.date, symbols:options.symbols, symbols1:options.symbols1, symbols2:options.symbols2, 
							gKey:options.gKey, rows:options.rows, dirf:options.dirf, gubn:options.gubn, subg:options.subg, desc:options.desc, vend:options.vend, 
							seqn:options.seqn, indx:options.indx, igap:options.igap, iKey:options.iKey, page:options.page, save:options.save};

				self._pushOnSend(data, options.receive);
			},1);
		};

		this._pushOnSend=function(data, receive) {
			
			if(self.socketConnection) {
				if(typeof data.value=='undefined' || data.value==null) {
					data.value='';
				}
				var xWinyWin=data.xWin+'_'+data.yWin;
				var win_name=data.pName+'_'+data.vName;
				var idx=packetList.indexOf(xWinyWin);
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
					
					if(!win_check) {
						
						var obj=[];
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
						socket.emit('pushON',data);
					}
				} else {
					packetList.push(xWinyWin);
					packetListData.push({WINS:[]});

					var obj=[];
					var ctl=mainFrame.nexMdi.getCtl(data.pName, data.vName);

					if(typeof receive =='function'){
						packetListData[packetListData.length-1].WINS.push({ID:win_name, REQGBN:data.reqGbn, VALUE:[],OBJECT:receive, REAL:obj});
					} else {
						packetListData[packetListData.length-1].WINS.push({ID:win_name, REQGBN:data.reqGbn, VALUE:[],OBJECT:null ,REAL:obj});
					}
					
					packetListData[packetListData.length-1].WINS[packetListData[packetListData.length-1].WINS.length-1].VALUE.push(data.value.trim());
					
					if(typeof socket != 'undefined' && socket != null) {
						socket.emit('pushON',data);
					}
				}
			}
		};

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

			if(parentName==viewName) {
				for(var k=0;k<packetList.length;k++) {
					for(var i=0;i<packetListData[k].WINS.length;i++) {
						if(packetListData[k].WINS[i].ID.indexOf(parentName+'_')>-1) {
							var arr_name=packetListData[k].WINS[i].ID.split('_');
							var reqGbn=packetListData[k].WINS[i].REQGBN;
							
							/*
							var arr_value;
							
							if($.isArray(packetListData[k].WINS[i].VALUE)) {
								arr_value=packetListData[k].WINS[i].VALUE.slice(0);
							} else {
								arr_value=packetListData[k].WINS[i].VALUE;
							}

							self.pushOff({code:packetList[k], pName:parentName, vName:arr_name[1], value:arr_value});
							*/
							var win=packetList[k].split('_');
							self.pushOff({reqGbn:reqGbn, xWin:win[0], yWin:win[1], pName:parentName, vName:arr_name[1]});
						}
					}
				}
			} else {
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
								socket.emit('pushOFF',{reqGbn:reqGbn, svcc:parentName, xWin:xWin, yWin:yWin});
							}

							/*
							if(!value_check)	{
								if(value_val=='null') {
									value_val='';
								}

								if(typeof socket != 'undefined' && socket != null) {
									//socket.emit('realdel', reqstr.join(''));
									socket.emit('pushOFF',{command:'pushOFF',type:code});
									//socket.json.send({command:'pushOFF', type:code});
								}
							}
							*/
						}
					}
				}
			}
		};
	}
	window.nexClient = new nexClient();
})(window, jQuery)