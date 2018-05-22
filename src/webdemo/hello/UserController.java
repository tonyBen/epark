package webdemo.hello;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.junit.runner.Request;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/")
public class UserController {
    
    private static final Logger log = Logger.getLogger(UserController.class);

    @RequestMapping("/hello")
    public String hello(){        
        return "hello";
    }
    
    @RequestMapping(value = "/user/{id}", method = RequestMethod.GET, produces = "application/json")
    public User getUser(@PathVariable("id") int id){        
        log.info("get user " + id);
        User user = new User();
        user.setId(id);
        user.setName("Hello");
        System.out.println();
        return user;
    }
    
    @RequestMapping(value = "/userlist", method = RequestMethod.GET, produces = "application/json")
    public List<User> getUserlist(){        
        System.out.println("get userlist");
        List<User> list = new ArrayList<User>();
        for(int i=1;i<10;i++){
            User user = new User();
            user.setId(i);
            user.setName("Hello");
            list.add(user);
        }
        return list;
    }
}