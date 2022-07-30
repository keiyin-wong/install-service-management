<%@ page pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="unix-login">
    <div class="container-fluid">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="login-content">
                  <!--   <div class="login-logo">
                        <a href="index.html"><span>Focus</span></a>
                    </div> -->
                    <div class="login-form">
                        <h4>User Login</h4>
                        <form action="${pageContext.request.contextPath}/j_spring_security_check" method="post">
                            <div class="form-group">
                                <label>UserName</label>
                                <input type="text" name="username" class="form-control" placeholder="User name">
                            </div>
                            <div class="form-group">
                                <label>Password</label>
                                <input type="password" name="password" class="form-control" placeholder="Password">
                            </div>
                            <div class="checkbox">
	                            <label>
									<input type="checkbox"> Remember Me
								</label>
								<label class="pull-right">
									<a href="#">Forgotten Password?</a>
								</label>
                            </div>
                            <button type="submit" class="btn btn-primary btn-flat m-b-30 m-t-30">Sign in</button>
                            <!-- <div class="social-login-content">
                                <div class="social-button">
                                    <button type="button" class="btn btn-primary bg-facebook btn-flat btn-addon m-b-10"><i class="ti-facebook"></i>Sign in with facebook</button>
                                    <button type="button" class="btn btn-primary bg-twitter btn-flat btn-addon m-t-10"><i class="ti-twitter"></i>Sign in with twitter</button>
                                </div>
                            </div>
                            <div class="register-link m-t-15 text-center">
                                <p>Don't have account ? <a href="#"> Sign Up Here</a></p>
                            </div> -->
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>