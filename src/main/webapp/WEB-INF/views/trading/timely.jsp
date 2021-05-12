<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	$(document).ready(function(){
		$('#timelyTbl').floatThead('destroy');
		
		$("#grdTimely").find("tr").remove();
		$("#timelyNext").val("");
		$("#timelySkey").val("");
		getTimelyList();
		scrollDataMore("getTimelyList()", $("#tab25 > .grid_area"));
		
		$('#timelyTbl').floatThead({
			position: 'relative',
			zIndex: function($table){
		        return 0;
		    },
			scrollContainer: true
		    //, autoReflow:true
		});
	});
</script>

<div class="tab_content">
	<input type="hidden" id="timelyNext" name="timelyNext" value=""/>
	<input type="hidden" id="timelyRcod" name="timelyRcod" value=""/>
	<div role="tabpanel" class="tab_pane" id="tab25">
		<!-- Timely -->
		<div class="grid_area" style="height: 435px;">
			<div class="group_table">
				<table class="table" id="timelyTbl">
					<colgroup>
						<col width="11%">
						<col>
						<col>
						<col>
						<col>
						<col>
					</colgroup>
					<thead>
						<tr>
							<th><%= (langCd.equals("en_US") ? "Time" : "Thời gian") %></th>
							<th><%= (langCd.equals("en_US") ? "Current" : "Giá hiện tại") %></th>
							<th><%= (langCd.equals("en_US") ? "+/-" : "+/-") %></th>
							<th><%= (langCd.equals("en_US") ? "%Change" : "%Thay đổi") %></th>
							<th><%= (langCd.equals("en_US") ? "Volume" : "Khối lượng") %></th>
							<th><%= (langCd.equals("en_US") ? "Total Volume" : "Tổng khối lượng") %></th>
						</tr>
					</thead>
					<tbody id="grdTimely">
					</tbody>
				</table>
			</div>
		</div>
		<!-- //Timely -->
	</div>
</div>
</html>