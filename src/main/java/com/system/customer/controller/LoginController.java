package com.system.customer.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.system.customer.model.User;

@Controller
@RequestMapping("/")
public class LoginController {
	private static final Logger log = Logger.getLogger(LoginController.class);

	/*
	 * Add user in model attribute
	 */
	@ModelAttribute("user")
	public User setUpUserForm() {
		return new User();
	}

	@GetMapping("/home")
	public String index() {
		return "index";
	}

	@PostMapping("/dologin")
	public String doLogin(@ModelAttribute("user") User user, Model model) throws IOException {
		RequestAttributes ra = RequestContextHolder.getRequestAttributes();
		HttpServletRequest request = ((ServletRequestAttributes) ra).getRequest();
		request.getSession(true).setAttribute("message", "testvalue");
		System.out.println(user);
		//return "index";
		/**
		// Implement your business logic
		if (user.getEmail().equals("sunil@example.com") && user.getPassword().equals("abc@123")) {
			// Set user dummy data
			user.setFname("Sunil");
			user.setMname("Singh");
			user.setLname("Bora");
			user.setAge(28);
		} else {
			model.addAttribute("message", "Login failed. Try again.");
			return "index";
		}
		*/
		return "success";
	}
}
