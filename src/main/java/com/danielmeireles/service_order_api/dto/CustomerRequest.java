package com.danielmeireles.service_order_api.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CustomerRequest(

        @NotBlank(message = "Name is required")
        @Size(max = 120)
        String name,

        @NotBlank(message = "Phone is required")
        @Size(max = 20)
        String phone,

        @Email(message = "Invalid email")
        @Size(max = 150)
        String email
) {
}