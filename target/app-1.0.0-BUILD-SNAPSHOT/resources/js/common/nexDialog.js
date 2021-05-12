(function(window, $, undefined) {
  var nexDialog = function() {
    this.HTML_PATH = '/advancement/jsp/trading/html/dialog/';
    this.JS_PATH = '/advancement/jsp/trading/js/controller/dialog/';
    this.PRIFIX = 'dia';
    this.CLASS_NAME = 'nexDialog_popup';
    this.NAME = 'Dialog';
    this.TITLE_NAME = 'Title';
    this.CLOSE_NAME = 'Close';
    this.OK_NAME = 'Ok';
    this.CANCEL_NAME = 'Cancel';
    this._dragging = false;
    this._target;
    this._mouseX;
    this._mouseY;
    this._mousePosX;
    this._mousePosY;
    this._oldFunction;
    this._dialogBg = false;
    this.dialogCnt = 0;
    //this.msgDialogCnt=0;
    this._func = [];
    this.masterCodeChk = false;
    this.options = {
      viewName: null,
      parentName: null,
      value: null,
      position: 'screen-center',
      x: 0,
      y: 0,
      positionTagId: null,
      positionTagName: null,
      bgClickHide: false,
      bgShow: true,
      openGbn: 'create'
    };
  }

  nexDialog.prototype = {

    /**
     * desc : Dialog Controller init 함수 실행
     * date : 2015.07.23
     * author : 천창환
     * ex : nexDialog.ctlRun(viewName, parentName, value)
     * @param viewName: dialog 화면 이름
     * @param parentName : dialog 부모화면 이름
     * @param value : dialog Controller 에 전달할 값
     */
    ctlRun: function(viewName, parentName, value) {
      var idx = this._funcFind(viewName);
      if (idx > -1) {
        this._func[idx].func.init(parentName, value);
      }
    },

    /**
     * desc : Dialog Controller Return
     * date : 2015.07.23
     * author : 천창환
     * ex : nexDialog.getCtl(viewName)
     * @param viewName: dialog 화면 이름
     * @return {Controller}
     */
    getCtl: function(viewName) {
      var idx = this._funcFind(viewName);
      if (idx > -1) {
        return this._func[idx].func;
      }
    },

    /**
     * desc : Dialog Controller Destroy
     * date : 2015.07.23
     * author : 천창환
     * ex : nexDialog.ctlDestroy(viewName)
     * @param viewName: dialog 화면 이름
     */
    ctlDestroy: function(viewName) {
      //마우스 키보드입력 객체 제거 (2014/10/14 추가)
      /*
      $('#'+viewName+' input[type=password]').each(function(){
      	transkey[this.id]=null;
      	$('#'+this.id+"_layout").remove();
      });
      */
      var idx = this._funcFind(viewName);

      if (idx > -1) {
        if (this._func[idx].cnt > 1) {
          this._func[idx].cnt--;
        } else {
          this._func.splice(idx, 1);
        }
      }
    },

    _funcFind: function(viewName) {
      for (var i = 0; i < this._func.length; i++) {
        if (this._func[i].viewName == viewName) {
          return i;
        }
      }

      return -1;
    },

    /**
     * desc : Dialog Open
     * date : 2015.07.23
     * author : 천창환
     * ex : nexDialog.open(options)
     * @param viewName: dialog 화면 이름
     * @param parentName: dialog 부모화면 이름
     * @param value: dialog Controller 에 전달 값
     * @param position: dialog Open 위치 설정  ('screen-top-left', 'screen-center', 'screen-bottom-right', 'mouse', 'element-bottom', 'element-right', 'element-bottom-right') default: 'screen-center'
     * @param x: dialog 위치 x 좌표 ( 단위 픽셀 ) default: 0
     * @param y: dialog 위치 y 좌표 ( 단위 픽셀 ) default: 0
     * @param positionTagId: position이 element 일경우 해당 element Id 값
     * @param positionTagName: position이 element 일경우 해당 element Name 값
     * @param bgClickHide: dialog Background 클릭시 닫기 설정 default: false
     * @param bgShow: dialog Background 설정 (true일경우 dialog 뒤에 화면 클릭 불가) default: true
     */
    open: function(options) {
      var self = this;
      this.options = $.extend(this.options, options);
      if (this.options.parentName == null) {
        this.options.parentName = this.options.viewName;
      }

      $.get(this.HTML_PATH + this.PRIFIX + this.options.viewName + '.html', function(data, status) {

		var idx = self._funcFind(self.options.viewName);

        if (idx > -1) {
          //$("."+self.CLASS_NAME).find("h4").focus(); // dia창 초점 초기화
          //$("."+self.CLASS_NAME).find(".dtit_news").focus(); // 0101뉴스, 0630뉴스공시 상세 dia창 초점 초기화
          self._func[idx].cnt++;
          self._func[idx].func.init(self.options.parentName, value);
        } else {
          require([self.JS_PATH + self.PRIFIX + self.options.viewName + '.js'], function requireSuccess(func) {
            //$("."+self.CLASS_NAME).find("h4").focus(); // dia창 초점 초기화
            //$("."+self.CLASS_NAME).find(".dtit_news").focus(); // 0101뉴스, 0630뉴스공시 상세 dia창 초점 초기화
        	/*
            var tempFunc = new func();

            var obj = {};
            obj.viewName = self.options.viewName;
            obj.func = tempFunc;
            obj.cnt = 1;
			obj.fids ={};
            tempFunc.init(self.options.parentName, self.options.value);

            self._func.push(obj);
            */
			self._create(data, self.options, func);

          }, function requireFail() {
            alert(self.JS_PATH + self.PRIFIX + self.options.viewName + '.js file Load fail');
          });
        };

      });
    },
    /**
     * desc : Dialog 닫기
     * date : 2015.07.23
     * author : 천창환
     * ex : nexDialog.close(viewName)
     * @param viewName: dialog 화면 이름
     */
    close: function(viewName) {
      //마우스 키보드입력 객체 제거 (2014/10/14 추가)
      /*
      $('#'+code+' input[type=password]').each(function(){
      	transkey[this.id]=null;
      	$('#'+this.id+"_layout").remove();
      });
      */

      // 다이얼로그 호출한 버튼 포커스 처리
      //$(".desktop-window-container").find(".foc_flag").focus().removeClass("foc_flag");

      //this._destroy(viewName + '_dialog');
      this._destroy(viewName); // 20150724 김행선 수정
    },
	confirm: function(func, msg, title) {
		var options={};
		var self = this;
		options.openGbn = 'show';
		options.bgShow = true;
		options.bgClickHide=false;
		options.position='screen-center';
		options.x = -160;
		options.y = -100;

		this.dialogCnt++;
		var zindex = 1000 + this.dialogCnt;
		
		options.viewName='messageBox'+'_'+zindex;
		this._backDivControl(options.bgShow, options.viewName, zindex, options.bgClickHide);

		var dialog_obj = document.getElementById(options.viewName + this.NAME);

		if (dialog_obj) {
			var dialog_parent = dialog_obj.parentNode;
			dialog_parent.removeChild(dialog_obj);
		}

		if(title == undefined || title == null || title.trim() == '') {
			title='알림';
		}

		var drag_id = options.viewName + this.TITLE_NAME;
		var close_id = options.viewName + this.CLOSE_NAME;
		var ok_btn_id = options.viewName + this.OK_NAME+'Btn';
		var cancel_btn_id = options.viewName + this.CANCEL_NAME;

		msg=nexUtils.unTextAreaBrchars(msg);

		var html='<div id="'+options.viewName+'" class="layer_sub" style="width:350px;">';
		html+='<h4 id="'+drag_id+'" style="padding-left:5px">'+title+'</h4>';
		html+='<div class="layer_body">';
		html+='<div class="just_text" style="min-height:50px;padding:5px">';
		html+=msg;
		html+='</div>';
		html+='<div class="mdi_bottom sub" style="padding-bottom:8px">';
		html+='<button type="button" id="'+ok_btn_id+'">확인</button>&nbsp;&nbsp;&nbsp;&nbsp;';
		html+='<button type="button" id="'+cancel_btn_id+'">취소</button>';
		html+='</div>';
		html+='</div>';
		html+='<button type="button" id="'+close_id+'" class="btn_close">레이어닫기</button>';
		html+='</div>';

		var oDiv = document.createElement('div');
		oDiv.id = options.viewName + this.NAME;

		oDiv.style.display = 'none';
		oDiv.style.zIndex = String(zindex + 1);
		oDiv.innerHTML = html;
		window.document.body.appendChild(oDiv);

      var return_fn = function() {
        return false;
      };
      var ok_fn = function() {
		self._destroy(options.viewName);
		func();
		return false;
      };

	  var ok_element=document.getElementById(ok_btn_id);

      if (ok_element) {
        if (ok_element.attachEvent) {
          ok_element.detachEvent('onclick', ok_fn);
          ok_element.detachEvent('onclick', return_fn);
          ok_element.attachEvent('onclick', ok_fn);
          ok_element.attachEvent('onclick', return_fn);
        } else {
          ok_element.removeEventListener('click', ok_fn, false);
          ok_element.removeEventListener('click', return_fn, false);
          ok_element.addEventListener('click', ok_fn, false);
          ok_element.addEventListener('click', return_fn, false);
        }
      }

		this._draw(options);
	},
	alert: function(msg, title, func) {
		var options={};
		var self = this;
		options.openGbn = 'show';
		options.bgShow = true;
		options.bgClickHide=false;
		options.position='screen-center';
		options.x = -160;
		options.y = -100;

		this.dialogCnt++;
		var zindex = 1000 + this.dialogCnt;
		
		options.viewName='messageBox'+'_'+zindex;
		this._backDivControl(options.bgShow, options.viewName, zindex, options.bgClickHide);

		var dialog_obj = document.getElementById(options.viewName + this.NAME);

		if (dialog_obj) {
			var dialog_parent = dialog_obj.parentNode;
			dialog_parent.removeChild(dialog_obj);
		}

		if(title == undefined || title == null || title.trim() == '') {
			title='알림';
		}

		var drag_id = options.viewName + this.TITLE_NAME;
		var close_id = options.viewName + this.CLOSE_NAME;
		var ok_btn_id = options.viewName + this.OK_NAME;
		var cancel_btn_id = options.viewName + this.CANCEL_NAME;

		if(func!==undefined) {
			close_id+='Btn';
			ok_btn_id+='Btn';
		}

		msg=nexUtils.unTextAreaBrchars(msg);

		var html='<div id="'+options.viewName+'" class="layer_sub" style="width:350px;">';
		html+='<h4 id="'+drag_id+'" style="padding-left:5px">'+title+'</h4>';
		html+='<div class="layer_body">';
		html+='<div class="just_text" style="min-height:50px;padding:5px">';
		html+=msg;
		html+='</div>';
		html+='<div class="mdi_bottom sub" style="padding-bottom:8px">';
		html+='<button type="button" id="'+ok_btn_id+'">확인</button>';
		html+='</div>';
		html+='</div>';
		html+='<button type="button" id="'+close_id+'" class="btn_close">레이어닫기</button>';
		html+='</div>';

		var oDiv = document.createElement('div');
		oDiv.id = options.viewName + this.NAME;

		oDiv.style.display = 'none';
		oDiv.style.zIndex = String(zindex + 1);
		oDiv.innerHTML = html;
		window.document.body.appendChild(oDiv);

		if(func!==undefined) {
		  var return_fn = function() {
			return false;
		  };
		  var ok_fn = function() {
			self._destroy(options.viewName);
			func();
			return false;
		  };

		  var ok_element=document.getElementById(ok_btn_id);

		  if (ok_element) {
			if (ok_element.attachEvent) {
			  ok_element.detachEvent('onclick', ok_fn);
			  ok_element.detachEvent('onclick', return_fn);
			  ok_element.attachEvent('onclick', ok_fn);
			  ok_element.attachEvent('onclick', return_fn);
			} else {
			  ok_element.removeEventListener('click', ok_fn, false);
			  ok_element.removeEventListener('click', return_fn, false);
			  ok_element.addEventListener('click', ok_fn, false);
			  ok_element.addEventListener('click', return_fn, false);
			}
		  }

		  var close_element=document.getElementById(close_id);

		  if (close_element) {
			if (close_element.attachEvent) {
			  close_element.detachEvent('onclick', ok_fn);
			  close_element.detachEvent('onclick', return_fn);
			  close_element.attachEvent('onclick', ok_fn);
			  close_element.attachEvent('onclick', return_fn);
			} else {
			  close_element.removeEventListener('click', ok_fn, false);
			  close_element.removeEventListener('click', return_fn, false);
			  close_element.addEventListener('click', ok_fn, false);
			  close_element.addEventListener('click', return_fn, false);
			}
		  }
		}

		this._draw(options);
	},
    /**
     * desc : Dialog Show ( document에 포함된 hide된 layer show 처리 )
     * date : 2015.07.23
     * author : 천창환
     * ex : nexDialog.show(options)
     * @param viewName: layer TagID
     * @param position: dialog Open 위치 설정  ('screen-top-left', 'screen-center', 'screen-bottom-right', 'mouse', 'element-bottom', 'element-right', 'element-bottom-right') default: 'screen-center'
     * @param x: dialog 위치 x 좌표 ( 단위 픽셀 ) default: 0
     * @param y: dialog 위치 y 좌표 ( 단위 픽셀 ) default: 0
     * @param positionTagId: position이 element 일경우 해당 element Id 값
     * @param positionTagName: position이 element 일경우 해당 element Name 값
     * @param bgClickHide: dialog Background 클릭시 닫기 설정 default: false
     * @param bgShow: dialog Background 설정 (true일경우 dialog 뒤에 화면 클릭 불가) default: true
     */
    show: function(options) {
      options.openGbn = 'show';
      this.dialogCnt++;
      var zindex = 1000 + this.dialogCnt;
      this._backDivControl(options.bgShow, options.viewName, zindex, options.bgClickHide);

      var dialog_obj = document.getElementById(options.viewName);

      dialog_obj.style.display = 'none';
      dialog_obj.style.zIndex = String(zindex + 1);

      this._draw(options);
    },
	trBind:function(val) {
		var idx = this._funcFind(val.viewName);
		this._func[idx].fid[val]
		for(var key in val.data) {
			var value=val.data[key];
			if(this._func[idx]!==undefined){
				var select_fid=this._func[idx].fid[key];
				if(select_fid!==undefined) {
					nexMdi._bind(select_fid, key, val.data, value);
				}
			}
		}
	},
	oopTrBind:function(val) {
		var idx = this._funcFind(val.viewName);
		for(var key in val.data) {
			if(key.length<6) {
				var cnt=6-key.length;
				for(var i=0;i<cnt;i++) {
					key+='0'+String(key);
				}
			}
			
			var value=String(val.data[key]);
			if(this._func[idx]!==undefined){
				var select_fid=this._func[idx].oop[key];
				
				if(select_fid!==undefined) {
					nexMdi._bind(select_fid, key, val.data, value);
				}
			}
		}
	},
	realBind:function(val) {
		var idx = this._funcFind(val.viewName);
		for(var key in val.data) {
			var value=val.data[key];
			if(this._func[idx]!==undefined){
				var select_fid=this._func[idx].real[key];
				if(select_fid!==undefined) {
					nexMdi._bind(select_fid, key, val.data, value);
				}
			}
		}
	},
    _create: function(data, options, func) {
 	  var self = this;
      options.openGbn = 'create';
      if (this.options.x == null) this.options.x = 0;
      if (this.options.y == null) this.options.y = 0;

      this.dialogCnt++;
      var zindex = 1000 + this.dialogCnt;
      this._backDivControl(options.bgShow, options.viewName, zindex, options.bgClickHide);

      var dialog_obj = document.getElementById(this.PRIFIX + options.viewName + this.NAME);

      if (dialog_obj) {
        var dialog_parent = dialog_obj.parentNode;
        dialog_parent.removeChild(dialog_obj);
      }

      var oDiv = document.createElement('div');
      oDiv.id = this.PRIFIX + options.viewName + this.NAME;
      oDiv.className = this.CLASS_NAME;

      oDiv.style.display = 'none';
      oDiv.style.zIndex = String(zindex + 1);
      oDiv.innerHTML = data;
      window.document.body.appendChild(oDiv);

	  $('#'+this.PRIFIX + options.viewName + this.NAME).find('[name^=tabs]').tabs();

	  var idx=this._funcFind(options.viewName);

	  var tempFunc = new func();

      var obj = {};
      obj.viewName = options.viewName;
      obj.func = tempFunc;
      obj.cnt = 1;
	  obj.real ={};
	  obj.fid ={};
	  obj.oop ={};

	  var selectors=$('#'+this.PRIFIX + options.viewName + this.NAME).find('[fid^=F]');
	  for(var i=selectors.length;i--;){
			var $selector=$(selectors[i]);
			var arr_fid=$selector.attr('fid').split(',');
			var fid=arr_fid[1].trim();
			var oop=arr_fid[2].trim();
			var real=arr_fid[3].trim();

			if(typeof obj.real[real] =='undefined') {
				obj.real[real]=[];
			}

			if(typeof obj.fid[fid] =='undefined') {
				obj.fid[fid]=[];
			}

			if(typeof obj.oop[oop] =='undefined') {
				obj.oop[oop]=[];
			}

			var fmt_func=$selector.attr('func');
			var func_obj=null;
			if(fmt_func) {
				try	{
					func_obj = eval(fmt_func);
				}catch (err){
					;
				}
			}
			var fmt=$selector.attr('fmt');
			var fmt_obj=null;
			if(fmt) {
				fmt_obj=fmt;
			}

			if(fid!='')
				obj.fid[fid].push({selector:$selector, func:func_obj, fmt:fmt_obj});

			if(real!='')
				obj.real[real].push({selector:$selector, func:func_obj, fmt:fmt_obj});

			if(oop!='')
				obj.oop[oop].push({selector:$selector, func:func_obj, fmt:fmt_obj});

	  }

      tempFunc.init(options.parentName, options.value);

      self._func.push(obj);

      this._draw(options);
    },

    _backDivColse: function(viewName) {
      this.close(viewName);
    },

    _backDivControl: function(bg_chk, id, zindex, bgClickHide) {

      var bg_id = this.NAME+'_bg_div_' + id;
      var self = this;
      if (bg_chk) {
        var dialog_bg_obj = document.getElementById(bg_id);

        if (dialog_bg_obj) {
          var dialog_bg_parent = dialog_bg_obj.parentNode;
          dialog_bg_parent.removeChild(dialog_bg_obj);
        }

        var div_bg = document.createElement('div');
        div_bg.id = bg_id;

        var scroll_left, scroll_top;
        var browser = navigator.userAgent.toLowerCase();

        if (browser.indexOf('msie 7') > -1 || browser.indexOf('msie 8') > -1 || browser.indexOf('msie 9') > -1) {
          scroll_left = document.documentElement.scrollLeft;
          scroll_top = document.documentElement.scrollTop;
        } else if (browser.indexOf('safari') > -1 || browser.indexOf('chrome') > -1) {
          scroll_left = document.body.scrollLeft;
          scroll_top = document.body.scrollTop;
        } else {
          scroll_left = document.documentElement.scrollLeft;
          scroll_top = document.documentElement.scrollTop;
        }

        div_bg.style.left = scroll_left + "px";
        div_bg.style.top = scroll_top + "px";
        div_bg.className = 'dia_back';
        div_bg.style.width = '100%';
        div_bg.style.height = '100%';
        div_bg.style.background = 'black';
        div_bg.style.opacity = 0.0;
        div_bg.style.MozOpacity = 0.0;
        div_bg.style.position = 'absolute';
        div_bg.style.overflow = 'auto';

        if (zindex) {
          div_bg.style.zIndex = String(zindex);
        } else {
          div_bg.style.zIndex = String(70000 + this.dialogCnt);
        }

        div_bg.style.filter = "alpha(opacity=0)";
        window.document.body.appendChild(div_bg);

        if (window.attachEvent) {
          window.detachEvent('onscroll', this._scroll);
          window.attachEvent('onscroll', this._scroll);
          if (bgClickHide) {
            div_bg.detachEvent('onclick', function() {
              self.close(id);
            });
            div_bg.attachEvent('onclick', function() {
              self.close(id);
            });
          }
        } else {
          window.removeEventListener('scroll', this._scroll, false);
          window.addEventListener('scroll', this._scroll, false);
          if (bgClickHide) {
            div_bg.removeEventListener('click', function() {
              self.close(id);
            });
            div_bg.addEventListener('click', function() {
              self.close(id);
            });
          }
        }
      }
    },

    _destroy: function(id) {
      //if (this.dialogCnt > 0) {
      //  this.dialogCnt--;
      //}

	  var dai_name='';

	  if(id.indexOf('messageBox')>-1) {
		  dai_name=id;
	  } else {
		  dai_name=this.PRIFIX+id;
	  }

      this.ctlDestroy(id);
      var dialog_obj1 = document.getElementById(dai_name+this.NAME);
	  var dialog_obj2 = document.getElementById(id);
	  if(dialog_obj1)	dialog_obj1.style.display = 'none';
	  if(dialog_obj2)	dialog_obj1.style.display = 'none';

      var dialog_bg_obj = document.getElementById(this.NAME+'_bg_div_' + id);

      if (dialog_bg_obj) {
        var dialog_bg_parent = dialog_bg_obj.parentNode;
        dialog_bg_parent.removeChild(dialog_bg_obj);
        this._dialogBg = false;
      }
    },

    _scroll: function(e) {
      var scroll_left, scroll_top;
      var browser = navigator.userAgent.toLowerCase();

      if (browser.indexOf('msie 7') > -1 || browser.indexOf('msie 8') > -1 || browser.indexOf('msie 9') > -1) {
        scroll_left = document.documentElement.scrollLeft;
        scroll_top = document.documentElement.scrollTop;
      } else if (browser.indexOf('safari') > -1 || browser.indexOf('chrome') > -1) {
        scroll_left = document.body.scrollLeft;
        scroll_top = document.body.scrollTop;
      } else {
        scroll_left = document.documentElement.scrollLeft;
        scroll_top = document.documentElement.scrollTop;
      }

      for (var key in document.getElementsByTagName('div')) {
        if (key.indexOf(this.NAME + "_bg_div_") > -1) {
          var dialog_bg_obj = document.getElementById(key);

          if (dialog_bg_obj) {
            dialog_bg_obj.style.left = scroll_left + "px";
            dialog_bg_obj.style.top = scroll_top + "px";
          }
        }
      }
    },

    _mouseDownWindow: function(e) {
      var ie = navigator.appName == "Microsoft Internet Explorer";
	  /*
      if (ie && window.event.button != 1) {
        return;
      }
      if (!ie && e.button != 0) {
        return;
      }
	  */

      nexDialog._dragging = true;
      nexDialog._target = this['target'];
      nexDialog._mouseX = ie ? window.event.clientX : e.clientX;
      nexDialog._mouseY = ie ? window.event.clientY : e.clientY;

      if (ie) {
        nexDialog._oldFunction = document.onselectstart;
      } else {
        nexDialog._oldFunction = document.onmousedown;
      }

      if (ie) {
        document.onselectstart = new Function("return false;");
      } else {
        document.onmousedown = new Function("return false;");
      }
    },

    _mouseDownEvent: function(e) {
      var ie = navigator.appName == "Microsoft Internet Explorer";

      this._mousePosX = ie ? window.event.clientX : e.clientX;
      this._mousePosY = ie ? window.event.clientY : e.clientY;
    },

    _mouseUpEvent: function(e) {
      var ie = navigator.appName == "Microsoft Internet Explorer";
      //var element = document.getElementById(nexDialog._target);

      if (!nexDialog._dragging) {
        return;
      }

      nexDialog._dragging = false;

      if (ie) {
        document.onselectstart = nexDialog._oldFunction;
      } else {
        document.onmousedown = nexDialog._oldFunction;
      }
    },

    _mouseMoveEvent: function(e) {
   	  var id=nexDialog._target;
      var ie = navigator.appName == "Microsoft Internet Explorer";
      var element = document.getElementById(id);
      var mouse_x = ie ? window.event.clientX : e.clientX;
      var mouse_y = ie ? window.event.clientY : e.clientY;

      if (!nexDialog._dragging) {
        return;
      }

      element.style.left = (element.offsetLeft + mouse_x - nexDialog._mouseX) + 'px';
      element.style.top = (element.offsetTop + mouse_y - nexDialog._mouseY) + 'px';

      nexDialog._mouseX = ie ? window.event.clientX : e.clientX;
      nexDialog._mouseY = ie ? window.event.clientY : e.clientY;
    },

    _exitEvent: function(e) {
      try {
  		var id='';
		var viewName='';

    	if(e.srcElement) {
    		id=e.srcElement.target;
    		viewName=e.srcElement.viewName;
    		
    	} else {
    		id=e.target.target;
    		viewName=e.target.viewName;
    	}
    	
        this._destroy(viewName);
        this._mouseUpEvent(e);
        return false;
      } catch (e) {}
    },

    _draw: function(options) {
      var self = this;
		
      var id = options.viewName + this.NAME;
      var drag_id = options.viewName + this.TITLE_NAME;
      var close_id = options.viewName + this.CLOSE_NAME;
      var ok_btn_id = options.viewName + this.OK_NAME;
      var cancel_btn_id = options.viewName + this.CANCEL_NAME;

	  if(options.openGbn == 'create') {
		  id = this.PRIFIX+options.viewName + this.NAME;
		  drag_id = this.PRIFIX+options.viewName + this.TITLE_NAME;
		  close_id = this.PRIFIX+options.viewName + this.CLOSE_NAME;
		  ok_btn_id = this.PRIFIX+options.viewName + this.OK_NAME;
		  cancel_btn_id = this.PRIFIX+options.viewName + this.CANCEL_NAME;
	  }
      var position = options.position;
      var parent_name = options.parentName;
      var position_name = options.positionTagName;
      var position_id = options.positionTagId;
      var x = parseInt(options.x);
      var y = parseInt(options.y);
      var element = document.getElementById(id);
      var close_element, cancel_element, ok_element, drag_element;

      if (document.getElementById(drag_id)) {
        drag_element = document.getElementById(drag_id);
        drag_element.style.cursor = "move";
      }

      close_element = document.getElementById(close_id);
      cancel_element = document.getElementById(cancel_btn_id);
      ok_element = document.getElementById(ok_btn_id);

      var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth;
      var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight;

      //if(gbn != 'my') {
      element.style.position = "absolute";

      element.style.display = "block";

      if (position == "element" || position == "element-right" || position == "element-bottom" || position == "element-bottom-right") {
        var position_element;

        if (position_name != null) {
          position_element = $("#mdi" + parent_name).find('[name=' + position_name + ']')[0];
        } else {
          position_element = document.getElementById(position_name);
        }

        if (position_element) {
          for (var p = position_element; p; p = p.offsetParent) {
            if (p.style.position != 'absolute') {
              x += p.offsetLeft;
              y += p.offsetTop;
            }
          }

          if (position == "element-right") x += position_element.clientWidth;
          if (position == "element-bottom") y += position_element.clientHeight;
          if (position == "element-bottom-right") {
            x += position_element.clientWidth - element.clientWidth;
            y += position_element.clientHeight;
          }
        }

        if (x < 0) x = 0;
        if (y < 0) y = 0;

        var viewport_scroll_top = 0;
        if (document.getElementById('nexMdiViewportContainer')) {
          viewport_scroll_top = document.getElementById('nexMdiViewportContainer').scrollTop;
        } else if (document.getElementById('popupViewportContainer')) {
          viewport_scroll_top = document.getElementById('popupViewportContainer').scrollTop;
        }

        element.style.left = x + 'px';
        element.style.top = (y - viewport_scroll_top) + 'px';
      }

      var scroll_left, scroll_top;
      var browser = navigator.userAgent.toLowerCase();

      if (browser.indexOf('msie 6') > -1 || browser.indexOf('msie 7') > -1 || browser.indexOf('msie 8') > -1 || browser.indexOf('msie 9') > -1) {
        scroll_left = document.documentElement.scrollLeft;
        scroll_top = document.documentElement.scrollTop;
      } else if (browser.indexOf('safari') > -1 || browser.indexOf('chrome') > -1) {
        scroll_left = document.body.scrollLeft;
        scroll_top = document.body.scrollTop;
      } else {
        scroll_left = document.documentElement.scrollLeft;
        scroll_top = document.documentElement.scrollTop;
      }

      var top = 0;
      var left = 0;
      if (position == "mouse") {
        left = scroll_left + this._mousePosX + x;
        top = scroll_top + this._mousePosY + y;

        if (left < 0) {
          left = 0;
        }
        if (top < 0) {
          top = 0;
        }

        element.style.left = left + 'px';
        element.style.top = top + 'px';
      }

      if (position == "screen-top-left") {
        left = scroll_left + x;
        top = scroll_top + y;

        if (left < 0) {
          left = 0;
        }
        if (top < 0) {
          top = 0;
        }

        element.style.left = left + 'px';
        element.style.top = top + 'px';
      }

      if (position == "screen-center") {
        left = scroll_left + (width - element.clientWidth) / 2 + x;
        top = scroll_top + (height - element.clientHeight) / 2 + y;

        if (left < 0) {
          left = 0;
        }
        if (top < 0) {
          top = 0;
        }

        element.style.left = left + 'px';
        element.style.top = top + 'px';
      }

      if (position == "screen-bottom-right") {
        left = scroll_left + (width - element.clientWidth) + x;
        top = scroll_top + (height - element.clientHeight) + y;

        if (left < 0) {
          left = 0;
        }
        if (top < 0) {
          top = 0;
        }

        element.style.left = left + 'px';
        element.style.top = top + 'px';
      }

      var fn = function() {
        self._exitEvent(window.event, id);
      };
      var return_fn = function() {
        return false;
      };

      if (close_element) {
        close_element['target'] = id;
		close_element['viewName'] = options.viewName;
        if (close_element.attachEvent) {
          close_element.detachEvent('onclick', fn);
          close_element.detachEvent('onclick', return_fn);
          close_element.attachEvent('onclick', fn);
          close_element.attachEvent('onclick', return_fn);
        } else {
          close_element.removeEventListener('click', fn, false);
          close_element.removeEventListener('click', return_fn, false);
          close_element.addEventListener('click', fn, false);
          close_element.addEventListener('click', return_fn, false);
        }
      }

      if (cancel_element) {
        cancel_element['target'] = id;
		cancel_element['viewName'] = options.viewName;
        if (cancel_element.attachEvent) {
          cancel_element.detachEvent('onclick', fn);
          cancel_element.detachEvent('onclick', return_fn);
          cancel_element.attachEvent('onclick', fn);
          cancel_element.attachEvent('onclick', return_fn);

        } else {
          cancel_element.removeEventListener('click', fn, false);
          cancel_element.removeEventListener('click', return_fn, false);
          cancel_element.addEventListener('click', fn, false);
          cancel_element.addEventListener('click', return_fn, false);
        }
      }

      if (ok_element) {
        ok_element['target'] = id;
		ok_element['viewName'] = options.viewName;
        if (ok_element.attachEvent) {
          ok_element.detachEvent('onclick', fn);
          ok_element.attachEvent('onclick', fn);
        } else {
          ok_element.removeEventListener('click', fn, false);
          ok_element.addEventListener('click', fn, false);
        }
      }

      if (document.getElementById(drag_id)) {
        drag_element['target'] = id;
		drag_element['viewName'] = options.viewName;
        drag_element.onmousedown = this._mouseDownWindow;
      }
    }
  }

  window.nexDialog = new nexDialog();


})(window, jQuery)
if (document.attachEvent) {
	document.attachEvent('onmousedown', nexDialog._mouseDownEvent);
	document.attachEvent('onmousemove', nexDialog._mouseMoveEvent);
	document.attachEvent('onmouseup', nexDialog._mouseUpEvent);
} else {
	document.addEventListener('mousedown', nexDialog._mouseDownEvent, false);
	document.addEventListener('mousemove', nexDialog._mouseMoveEvent, false);
	document.addEventListener('mouseup', nexDialog._mouseUpEvent, false);
}