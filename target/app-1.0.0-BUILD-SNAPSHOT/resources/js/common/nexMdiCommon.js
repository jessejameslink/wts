(function(window, $, undefined) {
  var nexMdiCommon = function() {
    this.ACTIVE_TAB_LOAD_CNT = 0;
    this.CONFIG_POPUP = false;
    this.MDI_ACTIVE_NUMBER = '';
    this.ACTIVE_TAB_SELECT_CNT = 0;
  }

  nexMdiCommon.prototype = {
    activeTabLoad: function(viewName) {
      var arr_tab = [];
      var role_tab = $("#mdi" + viewName).find("[role=tab]");

      for (var i = role_tab.length; i--;) {
        if ($(role_tab[i]).attr("aria-selected") == "true") {
          var view_name = $(role_tab[i]).attr("viewName"),
            run = $(role_tab[i]).attr("run"),
            init = $(role_tab[i]).attr("init");

          if (typeof init == 'undefined' || init == null || init == '') {
            init = 'true';
          }

          if (typeof view_name != 'undefined' && view_name != null && typeof run != 'undefined' && run == 'true' && init == 'true') {
            arr_tab.push(viewName + '_' + view_name);
          }

          if (init == 'false') {
            $(role_tab[i]).attr("init", "true");
          }
        }
      }

      ACTIVE_TAB_LOAD_CNT = 0;

      setTimeout(function() {
        this.tabLoad(arr_tab);
      }, 100);
    },

    /**
     * desc : mdi창 open 여부
     * date : 2015.07.28
     * author : 김행선
     * @param viewName : 화면번호
     * @return {Boolean}
     */
    isOpenWindow: function(viewName) {
      var isOpen = false;

      for (var i = 0, len = arrayFunc.length; i < len; i++) {
        if (arrayFunc[i].viewName.substr(0, 4) == viewName) {
          isOpen = true;
          break;
        }
      }

      return isOpen;
    },

    /**
     * desc : 활성화 된 텝 여부 확인
     * date : 2015.07.28
     * author : 김행선
     * @param viewName : 화면 번호
     * @param tabName : 탭 번호
     * @return {Boolean}
     */
    isActiveTab: function(viewName, tabName) {
      var role_tab = $("#mdi" + viewName).find("[role=tab]")
      for (var i = role_tab.length; i--;) {
        if ($(role_tab[i]).attr("aria-selected") == "true") {
          if (tabName == $(role_tab[i]).attr("viewName")) {
            return true;
          }
        }
      }

      return false;
    },

    /**
     * desc : 활성화 된 텝 번호 리턴
     * date : 2015.07.28
     * author : 김행선
     * @param viewName : 화면 번호
     * @param tabName : 탭 번호
     * @return {String}
     */
    isActiveTabViewName: function(viewName, tabName) {
      var role_tab = $("#mdi" + viewName).find("[role=tab]");

      for (var i = role_tab.length; i--;) {
        if ($(role_tab[i]).attr("aria-selected") == "true") {
          if (tabName.indexOf(",") != -1) {
            var tabNames = tabName.split(",");

            for (var j = tabNames.length; j--;) {
              if ($.trim(tabNames[j]) == $(role_tab[i]).attr("viewName")) {
                return $.trim(tabNames[j]);
              }
            }
          } else {
            if ($.trim(tabName) == $(role_tab[i]).attr("viewName")) {
              return $.trim(tabName);
            }
          }
        }
      }

      return '';
    },

    tabLoad: function(arr_tab) {
      if (ACTIVE_TAB_LOAD_CNT == 10) return;

      var del_list = [];
      for (var k = arr_tab.length; k--;) {
        var arr_name = arr_tab[k].split('_');
        var obj = getCtrl(arr_name[0], arr_name[1]);

        if (obj != null) {
          try {
            obj.search();
          } catch (e) {;
          }

          del_list.push(arr_tab[k]);
        }
      }

      var temp_arr_tab = [];
      for (var k = del_list.length; k--;) {

        // 배열indexOf, 배열splice, ie 하위버전(ie8)에서는 않됨, ie9부터 가능 --> stringUtils.js에 prototype 정의해둠
        arr_tab.splice(arr_tab.indexOf(del_list[k]));
      }

      if (arr_tab.length > 0) {
        setTimeout(function() {
          this.tabLoad(arr_tab);
        }, 100);
      }

      ACTIVE_TAB_LOAD_CNT++;
    },

    activeTabSelect: function(viewName, tabName) {
      if (this.ACTIVE_TAB_SELECT_CNT > 30) {
        this.ACTIVE_TAB_SELECT_CNT = 0;
        return;
      }

      viewName = viewName.replace('mdi', '');
      if (controllerReturn({
          parentName: viewName,
          viewName: tabName
        }) != null) {
        this.ACTIVE_TAB_SELECT_CNT = 0;
        if ($('#mdi' + viewName + " .tab_order").find("li[viewName='" + tabName + "']").find('a').length > 0) {
          $('#mdi' + viewName + " .tab_order").find("li[viewName='" + tabName + "']").find('a')[0].click();
        }
      } else {
        setTimeout(function() {
          activeTabSelect(viewName, tabName);
        }, 200);
      }
    },

    //MDI 메세지 히스토리 관련
    wtsHistoryMsg: function(viewName, msg) {
      var obj_date = new Date();
      var hour = obj_date.getHours();
      var min = obj_date.getMinutes();
      var sec = obj_date.getSeconds();
      var insert_time = '';

      if (hour.toString().length == 1) {
        insert_time += "0" + hour;
      } else {
        insert_time += hour;
      }

      if (min.toString().length == 1) {
        insert_time += ":0" + min;
      } else {
        insert_time += ":" + min;
      }

      if (sec.toString().length == 1) {
        insert_time += ":0" + sec;
      } else {
        insert_time += ":" + sec;
      }

      if (typeof mdi_open_wins != 'undefined') {
        for (var i = mdi_open_wins.length; i--;) {
          if (mdi_open_wins[i].viewName == viewName) {
            mdi_open_wins[i].historyMsg.push({
              time: insert_time,
              message: msg
            });
            break;
          }
        }
      }

      if (typeof arrayFunc != 'undefined') {
        for (var i = arrayFunc.length; i--;) {
          if (arrayFunc[i].viewName.indexOf(viewName + '_') > -1) {
            if (typeof arrayFunc[i].func.searchCheck != 'undefined') {
              arrayFunc[i].func.searchCheck = false;
            }

            if (typeof arrayFunc[i].func.orderCheck != 'undefined') {
              arrayFunc[i].func.orderCheck = false;
            }

            if (typeof arrayFunc[i].func.searchCheck_grid != 'undefined') {
              arrayFunc[i].func.searchCheck_grid = false;
            }

            if (typeof arrayFunc[i].func.searchCheck_chart != 'undefined') {
              arrayFunc[i].func.searchCheck_chart = false;
            }

            if (typeof arrayFunc[i].func.balaceCheck != 'undefined') {
              arrayFunc[i].func.balaceCheck = false;
            }
          }
        }
      }
    },

    /**
     * desc : MDI창 종목연동 Lock 설정(lockCheck: false 종목연동 사용, lockCheck: true 종목연동 미사용)
     * date : 2015.07.28
     * author : 김행선
     * @param viewName : 화면 번호
     */
    mdiLockToggle: function(viewName) {
      if (wtsConfig['eventLinkYN'] == '0') {
        for (var i = mdi_open_wins.length; i--;) {
          if (mdi_open_wins[i].viewName == viewName) {
            if (mdi_open_wins[i].lockCheck) {
              mdi_open_wins[i].lockCheck = false;
              $("#mdi" + viewName + "_lock_btn").removeClass('lock').addClass('lock_on');
            } else {
              mdi_open_wins[i].lockCheck = true;
              $("#mdi" + viewName + "_lock_btn").removeClass('lock_on').addClass('lock');
            }
            break;
          }
        }
      } else {
        alert('종목 연동이 설정되어 있지 않습니다.');
      }
    },

    /**
     * desc : 종목연동 사용(lockCheck: false 종목연동 사용, lockCheck: true 종목연동 미사용)
     * date : 2015.07.28
     * author : 김행선
     */
    mdiAllUnLock: function() {
      for (var i = mdi_open_wins.length; i--;) {
        if (mdi_open_wins[i].lockCheck) {
          mdi_open_wins[i].lockCheck = false;
          $("#mdi" + mdi_open_wins[i].viewName + "_lock_btn").removeClass('lock').addClass('lock_on');
        }
      }
    },

    asideMdiOpen: function(code, name) {
      // 주식
      var marketType = getMarketKubun(code);
      if (marketType == "Q" || marketType == "J") {

        //사이드메뉴 최근종목 히스토리 저장
        stockLately(code, name);

        // 최근검색종목 히스토리 저장
        cookieSet(code, 'eventsHistory', null, name);

        var b_type = getBrowserType();
        var check = false;
        var activeLockCheck = false;
        var activeMarket = '';
        for (var i = mdi_open_wins.length; i--;) {
          var lockCheck = mdi_open_wins[i].lockCheck;

          if (typeof this.MDI_ACTIVE_NUMBER != 'undefined' && mdi_open_wins[i].viewName == this.MDI_ACTIVE_NUMBER) {
            activeLockCheck = lockCheck;
            activeMarket = mdi_open_wins[i].viewInfo.market;
          }

          if (!lockCheck && mdi_open_wins[i].viewInfo.market == 'stock') {
            check = true;
            $("#mdi" + mdi_open_wins[i].viewName).find('input[name=stockcode_new]').val(code);

            if (b_type != 'IE9' && b_type != 'IE8' && b_type != 'IE7') {
              getCtrl(mdi_open_wins[i].viewName).search();
            }
          }
        }

        if (b_type == 'IE9' || b_type == 'IE8' || b_type == 'IE7') {
          if (!activeLockCheck && activeMarket == 'stock' && typeof this.MDI_ACTIVE_NUMBER != 'undefined' && this.MDI_ACTIVE_NUMBER != '') {
            getCtrl(this.MDI_ACTIVE_NUMBER).search();
          }
        }

        if (!check) openMdiWin({
          viewName: '6120',
          value: {
            refid: code
          }
        });
      }
    },

    /**
     * desc : MDI창 즐겨찾기 설정
     * date : 2015.07.28
     * author : 김행선
     * @param viewName : 화면 번호
     */
    mdiBookmarkToggle: function(viewName) {
      var menuCode = top.getMenuWTS(viewName);

      if ($("#mdi" + viewName + "_favorite_btn").attr('class') == 'favorite_on') {
        mdiBookmark('delete', menuCode.code, viewName);
      } else {
        mdiBookmark('insert', menuCode.code, viewName);
      }
    },

    //MDI창 즐겨찾기 설정 관련
    mdiBookmark: function(type, menuCode, viewName) {
      var params = 'cmd=' + type + '&MenuCode=' + menuCode;
      $.ajaxSend({
        url: "/main/bookmark.do",
        secure: 'Y',
        param: params,
        callback: function(data) {
          if ($.util.isEmpty(data.errorMsg)) {
            switch (type.toUpperCase()) {
              case 'INSERT':
                switch (String(data.BkmrStatus).toUpperCase()) {
                  case 'D':
                    $("#mdi" + viewName + "_favorite_btn").removeClass('favorite_on').addClass('favorite');
                    this.wtsHistoryMsg(viewName, '즐겨찾기를 삭제 했습니다.');
                    alert('즐겨찾기를 삭제 했습니다.');
                    break;

                  case 'U':
                    this.wtsHistoryMsg(viewName, '즐겨찾기는 50개만 지정할 수 있습니다.');
                    alert('즐겨찾기는 50개만 지정할 수 있습니다.');
                    break;

                  default:
                    $("#mdi" + viewName + "_favorite_btn").removeClass('favorite').addClass('favorite_on');
                    this.wtsHistoryMsg(viewName, '즐겨찾기를 추가 했습니다.');
                    alert('즐겨찾기에 추가 했습니다.');
                    break;
                };
                break;

              case 'DELETE':
                $("#mdi" + viewName + "_favorite_btn").removeClass('favorite_on').addClass('favorite');
                this.wtsHistoryMsg(viewName, '즐겨찾기를 삭제 했습니다.');
                alert('즐겨찾기를 삭제 했습니다.');
                break;
            };
          } else {
            alert(data.errorMsg);
          };
        }
      });
    },

    /**
     * desc : MDI창 즐겨찾기 설정
     * date : 2015.07.28
     * author : 김행선
     * @param viewName : 화면 번호
     */
    mdiMessageShow: function(viewName) {
      for (var i = mdi_open_wins.length; i--;) {
        if (mdi_open_wins[i].viewName == viewName) {
          var data = "<ul class=\"mdi-msg rndcnr\">";
          var msg = "";
          for (var k = mdi_open_wins[i].historyMsg.length; k--;) {
            msg += "<li class=\"msg-tmplt messages\" tabindex='0'>";
            msg += "<span class=\"time\">" + mdi_open_wins[i].historyMsg[k].time + "</span>";
            msg += "<span class=\"win-message\">" + mdi_open_wins[i].historyMsg[k].message + "</span>";
            msg += "</li>";
          }
          if (msg == "") {
            msg += "<li class=\"msg-tmplt messages\" tabindex='0'>";
            msg += "<span class=\"time\"></span>";
            msg += "<span class=\"win-message\">현재 메세지가 없습니다.</span>";
            msg += "</li>";
          }
          data += msg;
          data += "<li class=\"messages msg-close-btn\" id=\"messageHistory_close\"><span class=\"xbtn\" tabindex='0'>메세지 레이어 닫기</span></li></ul>";

          dialogCreate('messageHistory', data, 'type2', 'element-bottom', -225, 9, viewName, 'mdi' + viewName + '_massage_btn', true, 'id');
          break;
        }
      }
    },
    //Taskbar 우측 4개 버튼 관련
    taskbarBtnToggle: function(btn_id) {

      switch (btn_id) {
        case 'task_max_btn':
          $("#task_grid_btn").removeClass('win_grid').removeClass('win_grid_on').addClass('win_grid');
          $("#task_default_btn").removeClass('win_default').removeClass('win_default_on').addClass('win_default');
          $("#task_max_btn").removeClass('win_max').removeClass('win_max_on').addClass('win_max_on');
          break;

        case 'task_default_btn':
          $("#task_grid_btn").removeClass('win_grid').removeClass('win_grid_on').addClass('win_grid');
          $("#task_max_btn").removeClass('win_max').removeClass('win_max_on').addClass('win_max');
          $("#task_default_btn").removeClass('win_default').removeClass('win_default_on').addClass('win_default_on');
          break;

        case 'task_grid_btn':
          $("#task_max_btn").removeClass('win_max').removeClass('win_max_on').addClass('win_max');
          $("#task_default_btn").removeClass('win_default').removeClass('win_default_on').addClass('win_default');
          $("#task_grid_btn").removeClass('win_grid').removeClass('win_grid_on').addClass('win_grid_on');
          break;

        case 'task_popup_btn':
          if ($("#task_popup_btn").attr('class') == 'win_popup') {
            $("#task_popup_btn").removeClass('win_popup').removeClass('win_popup_on').addClass('win_popup_on');
          } else {
            $("#task_popup_btn").removeClass('win_popup').removeClass('win_popup_on').addClass('win_popup');
          }
          break;

        case 'task_wtsconnetion_btn':
          if ($("#task_wtsconnetion_btn").hasClass('realtime1')) {
            this.wtsConnectionOnOff(false);
          } else {
            this.wtsConnectionOnOff(true);
          }
          break;
      }
    },

    /**
     * desc : wtsConnectionStatus
     * date : 2015.07.28
     * author : 김행선
     */
    wtsConnectionStatus: function() {
      if ($("#task_wtsconnetion_btn").hasClass('realtime1')) {
        return true;
      } else {
        return false;
      }
    },

    /** 시세 서버 접속 실패시(최초 접속시, 노드서버 연결 X)
     * desc : siseConnectionError
     * date : 2015.07.28
     * author : 김행선
     * @param gbn
     */
    siseConnectionError: function(gbn) {},

    /** 접속 후 이용 도중에 MCA 연결이 끈어졌을 경우(재접속)
     * desc : mcaConnectionError
     * date : 2015.07.28
     * author : 김행선
     * @param gbn
     */
    mcaConnectionError: function(gbn) {},

    /** MCA 서버 모두 다운 됐을 경우
     * desc : mcaAllConnectionError
     * date : 2015.07.28
     * author : 김행선
     * @param gbn
     */
    mcaAllConnectionError: function(gbn) {},

    /** 접속 후 노드 서버 연결이 끊어졌을 경우 (재접속)
     * desc : siseServerDownError
     * date : 2015.07.28
     * author : 김행선
     * @param gbn
     */
    siseServerDownError: function(gbn) {
      var msgData = [];
      msgData['msgText'] = '실시간 시세 수신 통신이 단절되었습니다.<br />재접속 하시겠습니까?';
      msgData['msgTitle'] = '알림';
      msgData['gbn'] = gbn;

      dialogOpen('alert', 'type1', 'alert', {
        openerid: 'alert',
        params: msgData
      }, 'screen-top-left', '250', '250');
    },

    siseServerDownErrorProc: function(gbn) {
      if (gbn == 'mdi') {
        setTimeout(function() {
          this.wtsConnectionOnOff(true);
        }, 2000);
      } else {
        if (typeof realClient != 'undefined' && realClient != null) {
          realClient.nobodyLoginProc();

          function connetionOn() {
            if (count < 30) {
              if (!realClient.wtsConnection) {
                setTimeout(function() {
                  connetionOn();
                }, 500);
                count++;
              } else {
                var b_type = getBrowserType();
                if (b_type == 'IE9' || b_type == 'IE8' || b_type == 'IE7') {
                  if (typeof this.MDI_ACTIVE_NUMBER != 'undefined' && this.MDI_ACTIVE_NUMBER != '') {
                    getCtrl(this.MDI_ACTIVE_NUMBER).search();
                  }
                } else {
                  for (var i = mdi_open_wins.length; i--;) {
                    getCtrl(mdi_open_wins[i].viewName).search();
                  }
                }
              }
            } else {
              siseConnectionError('nobody');
            }
          }
          connetionOn();
        }
      }
    },

    wtsConnectionOnOff: function(check) {
      if (typeof realClient != 'undefined' && realClient != null) {
        if (typeof realClient.wtsConnection != 'undefined' && check != realClient.wtsConnection) {
          if (check) {
            var count = 0;
            realClient.memberLoginProc();

            function connetionOn() {
              if (count < 30) {
                if (!realClient.wtsConnection) {
                  setTimeout(function() {
                    connetionOn();
                  }, 500);
                  count++;
                } else {
                  var b_type = getBrowserType();
                  if (b_type == 'IE9' || b_type == 'IE8' || b_type == 'IE7') {
                    if (typeof this.MDI_ACTIVE_NUMBER != 'undefined' && this.MDI_ACTIVE_NUMBER != '') {
                      getCtrl(this.MDI_ACTIVE_NUMBER).search();
                    }
                  } else {
                    for (var i = mdi_open_wins.length; i--;) {
                      getCtrl(mdi_open_wins[i].viewName).search();
                    }
                  }
                  $("#task_wtsconnetion_btn").removeClass('realtime1').removeClass('realtime2').addClass('realtime1').attr('title', '실시간시세 제공중');
                }
              } else {
                siseConnectionError('mdi');
              }
            }
            connetionOn();
          } else {
            setTimeout(function() {
              realClient.WebSocketDisconnect();
            }, 10);
            $("#task_wtsconnetion_btn").removeClass('realtime1').removeClass('realtime2').addClass('realtime2').attr('title', '실시간시세 미제공중');
          }
        } else {
          if (check) {
            $("#task_wtsconnetion_btn").removeClass('realtime1').removeClass('realtime2').addClass('realtime1').attr('title', '실시간시세 제공중');
          } else {
            $("#task_wtsconnetion_btn").removeClass('realtime1').removeClass('realtime2').addClass('realtime2').attr('title', '실시간시세 미제공중');
          }
        }
      } else {
        if (check) {
          $("#task_wtsconnetion_btn").removeClass('realtime1').removeClass('realtime2').addClass('realtime1').attr('title', '실시간시세 제공중');
        } else {
          $("#task_wtsconnetion_btn").removeClass('realtime1').removeClass('realtime2').addClass('realtime2').attr('title', '실시간시세 미제공중');
        }
      }
    },

    /**
     * desc : Taskbar ' > ' 버튼
     * date : 2015.07.28
     * author : 김행선
     */
    task_btn_right: function() {
      var task_width = $("#taskbar_rolling")[0].offsetWidth;
      var task_count_width = 0;
      var hidden_no = [];
      var view_no = [];
      for (var i = $("#taskbar_rolling").find('li').length; i--;) {
        if ($("#taskbar_rolling").find('li')[i].style.display.indexOf('none') < 0) {
          task_count_width += 166;
          view_no.push(i);
        } else {
          hidden_no.push(i);
        }
      }

      if (task_count_width > task_width) {
        $($("#taskbar_rolling").find('li')[view_no[0]]).hide();
      }
    },

    /**
     * desc : Taskbar ' < ' 버튼
     * date : 2015.07.28
     * author : 김행선
     */
    task_btn_left: function() {
      var task_count_width = 0;
      var hidden_no = [];
      for (var i = $("#taskbar_rolling").find('li').length; i--;) {
        if ($("#taskbar_rolling").find('li')[i].style.display.indexOf('none') < 0) {
          task_count_width += 166;
        } else {
          hidden_no.push(i);
        }
      }

      if (hidden_no.length > 0) {
        $($("#taskbar_rolling").find('li')[hidden_no[hidden_no.length - 1]]).show();
      }
    },

    /**
     * desc : 키보드보안 클리어 처리
     * date : 2015.07.28
     * author : 김행선
     * @param {Object} win : nexMdiLib.$scope.window
     */
    mdiKdefClear: function(win) {
      $('#' + win.views[0].viewDirective + ' input[type=password]').each(function() {
        transkey[this.id] = null;
        $('#' + this.id + "_layout").remove();
      });
    },

    //키보드보안 관련
    kDefMouseInputScroll: function(self) {
      $("#nexMdiViewportContainer").unbind('scroll');
      if ($(self).find('input').is(":checked")) {
        var position_element = $(self).find('input')[0];
        var id = $(self).attr("id").replace("_tk_btn", "");
        var element = $("#" + id + "_layout")[0];
        setTimeout(function() {
          kDefMouseInputPosition(position_element, element);
        }, 0);
        $("#nexMdiViewportContainer").bind('scroll', function() {
          setTimeout(function() {
            kDefMouseInputPosition(position_element, element);
          }, 0);
        });
      }
    },

    //키보드보안 관련
    kDefMouseInputPosition: function(position_element, element) {
      var y = 5;
      for (var p = position_element; p; p = p.offsetParent) {
        if (p.style.position != 'absolute') {
          y += p.offsetTop;
        }
      }
      y += position_element.clientHeight;
      if (y < 0) y = 0;

      var viewport_scrollTop = 0;
      if (document.getElementById('nexMdiViewportContainer')) {
        viewport_scrollTop = document.getElementById('nexMdiViewportContainer').scrollTop;
      } else if (document.getElementById('popupViewportContainer')) {
        viewport_scrollTop = document.getElementById('popupViewportContainer').scrollTop;
      }

      element.style.top = (y - viewport_scrollTop) + 'px';
    },

    /**
     * desc : Taskbar 작업표시줄 왼쪽('<') 오른쪽('>') 버튼 클릭시 표현 처리
     * date : 2015.07.28
     * author : 김행선
     */
    taskWindowShow: function() {
      var task_width = $("#taskbar_rolling")[0].offsetWidth;
      var task_count_width = 0;
      var hidden_no = [];
      for (var i = $("#taskbar_rolling").find('li').length; i--;) {
        if ($("#taskbar_rolling").find('li')[i].style.display.indexOf('none') < 0) {
          task_count_width += 166;
        } else {
          hidden_no.push(i);
        }
      }

      if (task_count_width < task_width) {
        if (hidden_no.length > 0) {
          $($("#taskbar_rolling").find('li')[hidden_no[hidden_no.length - 1]]).show();
          taskWindowShow();
        }
      }
    },

    /**
     * desc : 사이드 메뉴 주요지수 데이터 로드
     * date : 2015.07.28
     * author : 김행선
     * @param gbn
     */
    asideIndex: function(gbn) {
      if (typeof gbn == 'undefined') gbn = false;

      var indexLst = [];
      if (typeof wtsConfig['basicInterIdxLst'] != 'undefined' && wtsConfig['basicInterIdxLst'] != null) {
        if (wtsConfig['basicInterIdxLst'].indexOf(',') > -1) {
          indexLst = wtsConfig['basicInterIdxLst'].split(',');
        } else {
          indexLst.push(wtsConfig['basicInterIdxLst']);
        }
      }
      //	//선물기본코드 값을 추가함.(2014.09.11) - 환경설정에 정의되어 있음.
      //	if (typeof masterCode.futureInitCode != 'undefined') {
      //		indexLst.push(masterCode.futureInitCode+'-F');
      //	}

      var tempar = [];
      for (var i = indexLst.length; i--;) {
        var arr_jisu = indexLst[i].split('-');
        var fid1000_ReqVo = new FidReqVo();
        fid1000_ReqVo.setGid('1000');
        fid1000_ReqVo.setIdx('fid1000_' + i);
        fid1000_ReqVo.setIsList('0');
        fid1000_ReqVo.setFidCodeBean('3', arr_jisu[0]);
        fid1000_ReqVo.setFidCodeBean('9104', arr_jisu[1]);
        fid1000_ReqVo.setOutFid('1,3,4,5,6,7,500'); //출력FID
        tempar[i] = fid1000_ReqVo;
      }

      //ASide 주요지수
      $.ajaxSend({
        url: "/wts/fidBuilder.do",
        gbn: 'vo',
        layerId: 'aside-index-loading',
        param: tempar,
        callback: function(data) {

          $("#aside-index-list").html("");
          var $selector = $("#aside-index");
          var arr_item1 = [],
            arr_item2 = [];
          for (var i = 0, len = indexLst.length; i < len; i++) {
            data['fid1000_' + i].data[0]['1'];

            var sisu_code = String(data['fid1000_' + i].data[0]['3']).trim();

            if (sisu_code != '') {
              if (sisu_code == '.DJI' || sisu_code == 'NXH1' || sisu_code == 'COMP' || sisu_code == 'SHANG' || sisu_code == '1DNH' || sisu_code == 'HK#HS' || sisu_code == 'SPX' || sisu_code == 'JP#NI225') {
                arr_item2.push(sisu_code);
              } else {
                arr_item1.push(sisu_code);
              }

              var html = '<li name="' + String(data['fid1000_' + i].data[0]['3']).trim() + '">';
              html += '<div class="p_ItemNm index_name"></div>';
              html += '<span class="p_CurPrc1 index_num"></span>';
              html += '<span class="p_CfSymbl up_low_num"></span>';
              html += '</li>';
              var $row = $(html);

              if (String(data['fid1000_' + i].data[0]['1']).trim() == '종합') {
                $($row).find('.p_ItemNm').text('KOSPI');
              } else if (String(data['fid1000_' + i].data[0]['1']).trim() == 'KQ 종합') {
                $($row).find('.p_ItemNm').text('KOSDAQ');
              } else {
                $($row).find('.p_ItemNm').text(String(data['fid1000_' + i].data[0]['1']).trim().toUpperCase());
              }

              formatter.$_selector = $row;
              formatter.setFid5(data['fid1000_' + i].data[0]['5']);
              formatter.fid4('.p_CurPrc1', String((Number(data['fid1000_' + i].data[0]['4'])).toFixed(2)));
              formatter.fid6('.p_CfSymbl', String((Number(data['fid1000_' + i].data[0]['6'])).toFixed(2)));
              $row.appendTo($($selector).find("ul"));
            }
          }

          if (gbn) {
            realClient.pbDataAdd('186', 'asideIndex', 'asideIndex', arr_item2);
            realClient.pbDataAdd('49', 'asideIndex', 'asideIndex', arr_item1);
          }
        }
      });
    },

    /**
     * desc : 사이드 메뉴 관심종목 데이터 로드
     * date : 2015.07.28
     * author : 김행선
     * @param gbn
     */
    asideFavorite: function(gbn) {
      if (typeof gbn == 'undefined') gbn = false;

      var fid1108ReqVo = new FidReqVo();
      fid1108ReqVo.setGid('1108');
      fid1108ReqVo.setFidCodeBean('3', ASIDEFAVLIST);
      fid1108ReqVo.setOutFid('1,3,4,5,6,7');

      var favList = ASIDEFAVLIST.split(',');
      var favMarket = [];
      if (favList.length > 0) {
        for (var i = favList.length; i--;) {
          favMarket[favList[i].substring(1)] = favList[i].substring(0, 1);
        }
      }

      $.ajaxSend({
        url: "/wts/fidBuilder.do",
        gbn: 'vo',
        param: [fid1108ReqVo],
        layerId: 'aside-favorite-loading',
        callback: function(data) {
          var fid1108 = data['fid1108']['data'];

          if (fid1108 != undefined) {
            ////시세 연동 완료 후 주석 제거
            //this._sync = {50:[]};
            var arr_code = [];
            var arr_jisucode = [];
            var mktSectCd = '';
            var stockcd = '';
            $("#aside-favorite-list").html("");
            var $selector = $("#aside-favorite");
            for (var n = 0, len = fid1108.length; n < len; n++) {
              //관심그룹에 등록된 종목 중 없어지는 종목도 존재할 수 있음. 그래서 데이터가 없는 경우 발생
              if (fid1108[n][3].trim() != '') {
                var json = fid1108[n];

                stockcd = json[3].trim();
                //masterCode가 로딩되지 않은 상태에서 호출하는 경우에 오류가 있음.
                //mktSectCd = getMarketKubun(stockcd);

                if (favMarket[stockcd] != undefined) {
                  mktSectCd = favMarket[stockcd];
                }

                if ('J' == mktSectCd || 'Q' == mktSectCd || 'M' == mktSectCd) {
                  arr_code.push(json[3].trim());
                } else if ('U' == mktSectCd) {
                  arr_jisucode.push(json[3].trim());
                }
                var html = '<li name="' + json[3].trim() + '">';
                html += '<div class="fid1 item_name">종목명</div>';
                html += '<span class="fid4 index_num"><span class="screen_out">상승</span>0</span>';
                html += '<span class="fid6 up_low_num"><span class="screen_out">하락</span>0</span>';
                html += '</li>';
                $row = $(html);

                $($row).find('.fid1').html('<a href="javascript:void(0);" onclick="nexMdiCommon.asideMdiOpen(\'' + json[3].trim() + '\',\'' + json[1].trim() + '\');return false;">' + json[1].trim() + '</a>'); //종목명

                formatter.$_selector = $row;
                formatter.setFid5(json[5]); //상한설정
                formatter.fid4(4, json[4]); //현재가
                formatter.fid6(6, json[6]); //등락폭 (대비)
                $row.appendTo($($selector).find("ul"));
              }
            }

            if (gbn) {
              realClient.pbDataAdd('50', 'asideFavorite', 'asideFavorite', arr_code);
              if (arr_jisucode.length > 0) {
                realClient.pbDataAdd('49', 'asideFavorite', 'asideFavorite', arr_jisucode);
              }
            }
          }
        }
      });
    },

    /**
     * desc :
     * date : 2015.07.28
     * author : 김행선
     * @param gbn
     * @param {Object} win : nexMdiLib.$scope.window
     */
    mdiActiveLoad: function(gbn, window) {
      if (typeof window != 'undefined' && window != null) {
        var mdiNum = window.views[0].viewDirective.replace('mdi', '');
        if (typeof this.MDI_ACTIVE_NUMBER != 'undefined') {
          this.MDI_ACTIVE_NUMBER = mdiNum;
        }

        if (typeof mdi_open_wins != 'undefined') {
          var b_type = getBrowserType();
          if (b_type == 'IE9' || b_type == 'IE8' || b_type == 'IE7') {
            for (var i = mdi_open_wins.length; i--;) {
              if (mdiNum != mdi_open_wins[i].viewName) {
                if (typeof realClient != 'undefined') {
                  realClient.pbMdiAllDel(mdi_open_wins[i].viewName);
                }
              }
            }

            if (gbn != 'open') {
              getCtrl(mdiNum).search();
            }
          }
        }
      } else {
        if (typeof this.MDI_ACTIVE_NUMBER != 'undefined') {
          this.MDI_ACTIVE_NUMBER = '';
        }
      }
    },

    /**
     * desc : MDI창 그리드 정렬 관련 처리
     * date : 2015.07.28
     * author : 김행선
     * @param {Object} win : nexMdiLib.$scope.window
     */
    mdiGridAlign: function(win) {
      var b_type = getBrowserType();
      var val = 50;
      if (b_type == 'IE9' || b_type == 'IE8' || b_type == 'IE7') {
        val = 180;
      }

      var window_top = Number(String(win.top).replace('px', ''));
      //var window_height=Number(String(window.height).replace('px',''));
      var view_port_obj = document.getElementById('nexMdiViewportContainer');
      var view_port_obj_scrollTop = view_port_obj.scrollTop;

      if (view_port_obj_scrollTop < window_top) {
        if ((window_top - view_port_obj.scrollTop) < 180) {
          return;
        }

        while (view_port_obj_scrollTop < window_top) {

          if ((view_port_obj_scrollTop + 30) > (window_top - val)) {

            view_port_obj.scrollTop = (window_top - val);
            break;
          }

          view_port_obj_scrollTop += 30;
        }
      } else {

        if ((view_port_obj.scrollTop - window_top) < 180) {
          return;
        }

        while (view_port_obj_scrollTop > window_top) {

          if ((view_port_obj_scrollTop - 30) < (window_top + val)) {
            view_port_obj.scrollTop = (window_top - val);
            break;
          } else if ((view_port_obj_scrollTop - 30) < 0) {
            view_port_obj.scrollTop = 0;
            break;
          }

          view_port_obj_scrollTop -= 30;
        }
      }
    },

    //MDI창 종목코드 연동 처리 관련
    mdiStockCodeLoad: function(viewName, code, market) {
      var view_info = null;
      var lock_check = false;
      for (var i = mdi_open_wins.length; i--;) {
        if (mdi_open_wins[i].viewName == viewName) {
          view_info = mdi_open_wins[i].viewInfo;
          lock_check = mdi_open_wins[i].lockCheck;
          break;
        }
      }

      var market_value = '';
      if (typeof market != 'undefined') {
        market_value = market;
      } else {

        /**
         * marketType
         * 상장수익증권 : h
         * 신주인수권증권 : s
         * 신주인수권증서 : c
         * K-OTC : T
         */
        var marketType = getMarketKubun(code);
        if (marketType == 'h' || marketType == 's' || marketType == 'c' || marketType == 'T') {
          market_value = marketType;
        } else {
          market_value = view_info.market;
        }
      }

      if (view_info != null && !lock_check) {
        for (var i = mdi_open_wins.length; i--;) {
          var lockCheck = mdi_open_wins[i].lockCheck;

          if (mdi_open_wins[i].viewName != viewName && !lockCheck && mdi_open_wins[i].viewInfo.market == market_value) {
            $("#mdi" + mdi_open_wins[i].viewName).find('input[name=stockcode_new]:eq(0)').val(code);
            var b_type = getBrowserType();
            if (b_type != 'IE9' && b_type != 'IE8' && b_type != 'IE7') {
              getCtrl(mdi_open_wins[i].viewName).search();
            }
          }
        }
      }
    },

    //환경설정 오픈
    wtsConfigPopup: function(tab1, tab2) {
      if (typeof tab1 == 'undefined') {
        tab1 = '';
      }
      if (typeof tab2 == 'undefined') {
        tab2 = '';
      }

      if (!this.CONFIG_POPUP) {
        this.CONFIG_POPUP = true;
        // dialogOpen('dia12000', 'type2', 'wtsConfig', {activeTab1:tab1,activeTab2:tab2});			// 'type2' 배경 클릭시 다이얼로그 창 닫힘.
        dialogOpen('dia12000', '', 'wtsConfig', {
          activeTab1: tab1,
          activeTab2: tab2
        });
      }
    }
  };

  window.nexMdiCommon = nexMdiCommon;
})(window, jQuery);
