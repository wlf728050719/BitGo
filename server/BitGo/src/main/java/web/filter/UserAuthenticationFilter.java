package web.filter;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.info.Result;
import domain.info.impl.util.JwtUtilInfo;
import util.JwtUtil;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;



@WebFilter(urlPatterns = {"/productSet","/productImageSet","/inventorySet","/orderSet","/commentSet","/userInfoSet","/userFavoriteSet"})
public class UserAuthenticationFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain){
        try {
            servletResponse.setContentType("application/json;charset=utf-8");
            String token = ((HttpServletRequest) servletRequest).getHeader("Authorization");
            if(token!=null){
                Result result = JwtUtil.validateToken(token);
                if(result.getInfo()==JwtUtilInfo.SUCCESS)
                {
                    String userId = (String) result.getValue();
                    servletRequest.setAttribute("userId", userId);
                    filterChain.doFilter(servletRequest, servletResponse);
                }
                else
                    servletResponse.getWriter().write(new ObjectMapper().writeValueAsString(result.getInfo()));
            }
            else
                servletResponse.getWriter().write(new ObjectMapper().writeValueAsString(JwtUtilInfo.FAIL));
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public void destroy() {
    }
}
