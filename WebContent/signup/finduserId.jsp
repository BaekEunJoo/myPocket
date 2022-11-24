<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
<script>
$(document).ready(function(){
	$("input:radio[name=option]").click(function(){
		
		if ($("input:radio[name=option]:checked").val() == 'phone'){
			$("#phone").removeClass('displaynone');
			$("#email").addClass('displaynone');
			
			
		}
		else if ($("input:radio[name=option]:checked").val() == 'email'){
			$("#email").removeClass('displaynone');
			$("#phone").addClass('displaynone');
		}
	});
});
	
function finduserId(frm){
	frm.action="/ourHW/controller?type=finduserId";
	frm.submit();
	return false;
}

</script>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<style>
	table {
    margin-left:auto; 
    margin-right:auto;
	}
	.displaynone { display: none; }

</style>


</head>

<body>
<jsp:include page="/common/header.jsp"></jsp:include>
<div class="w3-container w3-center">
	<br><br>
	<h4><strong>아이디 찾기</strong></h4>
	<br>
	<p>가입하신 방법에 따라 아이디 찾기가 가능합니다.</p>
	<form method="post">
	
	<input type="radio" value = "email" name="option" checked>이메일
	<input type="radio" value = "phone" name="option">휴대폰번호
	
	<table>
		<tr>
			<td>이름&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td><input class="w3-input" type="text" id="name" name="name"></td>
		</tr>
		<tr id="email">
			<td>이메일&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td><input class="w3-input" type="text" id="email" name="email"></td>
		</tr>
		<tr id="phone" class="displaynone">
			<td>휴대폰 번호&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td><input class="w3-input" type="text" id="phone" name="phone"></td>
		</tr>
	</table>
	<br>
	<input type="button" value="확인" class="w3-black w3-btn w3-large" onclick="finduserId(this.form)">
	</form>
	
</div>

<footer>
	<%@ include file="/common/footer.jspf" %>
</footer>

</body>
</html>