package com.vn.app.commons.logging;

import org.apache.log4j.Logger;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;

/**
 * AOP 클레스
 * kr.go.mps.milpen.app.commons.logging.VnLoggingAspect
 * @author [VN] 임수석
 * @since : 2016. 07. 05.
 * @version : 1.0
 * <pre>
 * << 개정이력 >>
 * 2016. 07. 05. [VN] 임수석 - 최초생성
 * </pre>
 */
@Aspect
public class VnLoggingAspect {
	
	private Logger sLogger = Logger.getLogger(VnLoggingAspect.class);
	
	/**
	 * 선언된 패키지의 하위 모든 클레스의 함수가 실행되기전에 로그를 찍는다.
	 * @param joinPoint	실행되는 함수
	 * @return	
	 * <pre>
	 * 2016. 07. 05. [VN] 임수석 - 최초작성
	 * </pre>
	 */
	@Before("execution(* com.vn.app..*(..))")
    public void logBefore(JoinPoint joinPoint) {
        //sLogger.info("*** logBefore() is running!");
        sLogger.info("*** Execute Function : " + joinPoint.getSignature().getName());
    }
}
