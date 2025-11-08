package com.tsei.www.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tsei.www.service.soms.somsService;

@Controller
@RequestMapping("/soms")
public class somsController {

    @Autowired
    private somsService service;

    @GetMapping("/page3")
    public String somsPage3(/* @AuthenticationPrincipal User user, Model model */) throws Exception {
//        model.addAttribute("loginId", user.getUsername());
//        model.addAttribute("loginRoles", user.getAuthorities());
        return "soms/page3";
    }

    @GetMapping("/page5")
    public String somsPage5(/* @AuthenticationPrincipal User user, Model model */) throws Exception {
//        model.addAttribute("loginId", user.getUsername());
//        model.addAttribute("loginRoles", user.getAuthorities());
        return "soms/page5";
    }
}


