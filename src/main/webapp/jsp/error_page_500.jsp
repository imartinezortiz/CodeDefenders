<%@ page isErrorPage="true" import="java.io.*" contentType="text/plain"%>
<!DOCTYPE h<!DOCTYPE html>
<html>
<head>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1" name="viewport">
    <title>The page you're looking for could not be found (404)</title>
    <style>
        body {
            color: #666;
            text-align: center;
            font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
            margin: auto;
            font-size: 14px;
        }

        h1 {
            font-size: 56px;
            line-height: 100px;
            font-weight: 400;
            color: #456;
        }

        h2 {
            font-size: 24px;
            color: #666;
            line-height: 1.5em;
        }

        h3 {
            color: #456;
            font-size: 20px;
            font-weight: 400;
            line-height: 28px;
        }

        hr {
            max-width: 800px;
            margin: 18px auto;
            border: 0;
            border-top: 1px solid #EEE;
            border-bottom: 1px solid white;
        }

        img {
            max-width: 40vw;
            display: block;
            margin: 40px auto;
        }

        a {
            line-height: 100px;
            font-weight: 400;
            color: #4A8BEE;
            font-size: 18px;
            text-decoration: none;
        }

        .container {
            margin: auto 20px;
        }

        .go-back {
            display: none;
        }

    </style>
</head>

<body>
	<a href="<%=request.getContextPath()%>"> <img
		src="<%=request.getContextPath()%>/images/logo.png">
	</a>

	<h1>
    500
</h1>
<div class="container">
    <h3>Internal Server Error</h3>
    <p>There has been a problem on our side.</p>
    <p>Sorry!</p>
    <p>Please try again and contact your administrator if this keeps happening.</p>
    <a href="javascript:history.back()" class="js-go-back go-back">Go back</a>
</div>
<script>
    (function () {
        var goBack = document.querySelector('.js-go-back');

        if (history.length > 1) {
            goBack.style.display = 'inline';
        }
    })();
</script>

</body>
</html>

