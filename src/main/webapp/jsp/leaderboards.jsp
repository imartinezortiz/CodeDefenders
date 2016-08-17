<%@ page import="org.codedefenders.multiplayer.MultiplayerGame" %>
<%@ page import="org.codedefenders.Role" %>
<%@ page import="org.codedefenders.*" %>
<% String pageTitle="Leaderboards"; %>
<%@ include file="/jsp/header.jsp" %>
	<%
		ArrayList<User> users = DatabaseAccess.getAllUsers();
	%>
<div class="w-100">
	<h3>Battlegrounds</h3>
	<table id="tableMPLeaderboard" class="table table-hover table-responsive table-paragraphs games-table dataTable display">
		<thead>
			<tr>
				<th class="col-sm-2">User</th>
				<th class="col-sm-2">Total Score</th>
				<th class="col-sm-1">Mutants</th>
				<th class="col-sm-2">Points as Attacker</th>
				<th class="col-sm-1">Tests</th>
				<th class="col-sm-2">Points as Defender</th>
				<th class="col-sm-2">Mutants Killed</th>
				<!--
				<th class="col-sm-2">Defender Wins</th>
				<th class="col-sm-2">Attacker Wins</th>
				-->
			</tr>
		</thead>
		<tbody>
		<%
			for (User u : users) {
		%>
		<tr>
			<td><%=u.getUsername()%></td>
			<td><%=DatabaseAccess.getUserPartyPointsTotal(u.getId())%></td>
			<td><%=DatabaseAccess.getNumPartyMutantsForUser(u.getId())%></td>
			<td><%=DatabaseAccess.getUserPartyPointsMutants(u.getId())%></td>
			<td><%=DatabaseAccess.getNumPartyTestsForUser(u.getId())%></td>
			<td><%=DatabaseAccess.getUserPartyPointsTests(u.getId())%></td>
			<td><%=DatabaseAccess.getNumPartyTestKillsForUser(u.getId())%></td>
			<!--
			<td></td>
			<td></td>
			-->
		</tr>
		<% } %>

		</tbody>
	</table>

	<script>
		$(document).ready(function() {
			$.fn.dataTable.moment( 'DD/MM/YY HH:mm' );
			$('#tableMPLeaderboard').DataTable( {
				"paging":   false,
				"searching": false,
				"order": [[ 1, "desc" ]],
				"language": {
					"info": ""
				}
			} );
		} );

		$('.modal').on('shown.bs.modal', function() {
			var codeMirrorContainer = $(this).find(".CodeMirror")[0];
			if (codeMirrorContainer && codeMirrorContainer.CodeMirror) {
				codeMirrorContainer.CodeMirror.refresh();
			} else {
				var editorDiff = CodeMirror.fromTextArea($(this).find('textarea')[0], {
					lineNumbers: false,
					readOnly: true,
					mode: "text/x-java"
				});
				editorDiff.setSize("100%", 500);
			}
		});
	</script>

</div>
<%@ include file="/jsp/footer.jsp" %>