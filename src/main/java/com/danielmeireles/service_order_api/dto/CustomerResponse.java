package com.danielmeireles.service_order_api.dto;

import java.time.OffsetDateTime;

public record CustomerResponse(
        Long id,
        String name,
        String phone,
        String email,
        OffsetDateTime createdAt
) {
}