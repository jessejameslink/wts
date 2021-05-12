<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	var newlistedfirst	=	true;
	$(document).ready(function(){
		$('#newlistedTbl').floatThead('destroy');		
		
		searchNewListedList();
		scrollDataMore("getNewListedList()", $("#tab6 > .grid_area"));
		
		$('.wrap_left button.wts_expand').on('click',function(){
			var existOn=$(this).parents('.left_content01').hasClass('on');
			var tabId = $("#tabOrdGrp4 ul li[class*=active]").attr("id");
			if(existOn){
				$(this).parents('.left_content01').removeClass('on');	
				$(this).text('+ EXPAND');
				/*if(tabId == "buytab") {
					$("#tab41").find("#bid_rcod").show();
					$("#tab41").find("#ent_sch_stock").hide();
				} else {
					$("#tab49").find("#bid_rcod").show();
					$("#tab49").find("#ent_sch_stock").hide();
				}*/
			}else{
				$(this).parents('.left_content01').addClass('on');
				$(this).text('- Reduce');
				/*if(tabId == "buytab") {
					$("#tab41").find("#bid_rcod").hide();
					$("#tab41").find("#ent_sch_stock").show();
				} else {
					$("#tab49").find("#bid_rcod").hide();
					$("#tab49").find("#ent_sch_stock").show();
				}*/
			}
			$('#newlistedTbl').floatThead('reflow');
		});
		
		
		var $table	=	$('#newlistedTbl');
		$('#newlistedTbl').floatThead({
			position: 'relative',
			zIndex: function($table){
		        return 0;
		    },
			scrollContainer: true
		});
	});

	function searchNewListedList() {
		$("#grdNewListed").find("tr").remove();
		$("#newlistedNext").val("");
		$("#newlistedSkey").val("");
		getNewListedList();
	}

	function getNewListedList() {
		if ($("#newlistedSkey").val() == "end") {
			return;
		}
		$("#tab6").block({message: "<span>LOADING...</span>"});
		var param = {
			  mark  : $("#mark3").val()
			, skey  : $("#newlistedSkey").val()
		};
		
		//console.log("Market select === " + $("#newlisted_tab").find("select[id='mark3']").val());
		
		$.ajax({
			url      : "/trading/data/getNewListedList.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.newlistedList != null) {
					if(data.newlistedList.list1 != null) {
						var htmlStr = "";
						for(var i=0; i < data.newlistedList.list1.length; i++) {
							var newlistedList = data.newlistedList.list1[i];
							var cssColor  = displayColor(newlistedList.diff.substring(0, 1));
							var cssArrow  = displayArrow(newlistedList.diff.substring(0, 1));
							htmlStr += "<tr style=\"cursor: pointer;\" onclick=\"selItem('" + newlistedList.symb + "');\">";
							htmlStr += "	<td class=\"text_left c_code\">" + newlistedList.symb + "</td>";                       // Stock							
							htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(newlistedList.curr.substring(1)) + "</td>"; // Current							
							htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + upDownNumList(newlistedList.diff.substring(1)) + "</td>"; // +/-
							htmlStr += "	<td>" + newlistedList.date + "</td>"; // Date
							htmlStr += "</tr>";
						}
						$("#grdNewListed").append(htmlStr);
					}
					
					if(newlistedfirst && $("#newlistedSkey").val() == "") {
						if(data.newlistedList.list1.length != 0 ) {
							selItem(data.newlistedList.list1[0].symb);
							newlistedfirst = false;
						}
					}
					
					if (data.newlistedList.skey == "" || data.newlistedList.skey == "0") {
						data.newlistedList.skey = "end";
					}
					if ($("#newlistedSkey").val() != "end") {
						$("#newlistedSkey").val(data.newlistedList.skey);
					}
				}
				
				$('#newlistedTbl').floatThead('reflow');
				
				$("#newlistedNext").val(data.newlistedList.next)
				$("#tab6").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab6").unblock();
			}
		});
	}
</script>

<div class="tab_content" id="newlisted_tab">
	<input type="hidden" id="newlistedNext" name="newlistedNext" value=""/>
	<input type="hidden" id="newlistedSkey" name="newlistedSkey" value=""/>
	<div role="tabpanel" class="tab_pane" id="tab6">
		<!-- NewListed -->
		<div class="table_right">
			<select id="mark3" id="mark3" width="150px;" style="width:82px;">
				<option value="0"><%= (langCd.equals("en_US") ? "All" : "Tất cả") %></option>
				<option value="1">HOSE</option>				
				<option value="2">HNX</option>				
				<option value="3">UPCOM</option>
			</select>			
			<button class="btn" type="button" onclick="searchNewListedList()"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu") %></button>
			<button class="wts_expand" type="button">+ EXPAND</button>
		</div>
		<div class="grid_area" style="height:251px;">
			<div class="group_table">
				<table class="table" id="newlistedTbl">
					<colgroup>
						<col width="5%" />
						<col />
						<col />
						<col />
					</colgroup>
					<thead>
						<tr>
							<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
							<th><%= (langCd.equals("en_US") ? "Price" : "Giá") %></th>
							<th><%= (langCd.equals("en_US") ? "Chg(+/-)" : "Thay đổi(+/-)") %></th>
							<th><%= (langCd.equals("en_US") ? "Date" : "Ngày") %></th>
						</tr>
					</thead>
					<tbody id="grdNewListed">
					</tbody>
				</table>
			</div>
		</div>
		<!-- //NewListed -->
	</div>
</div>
</html>
