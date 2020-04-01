//
//  PostBodyModels.swift
//  Homework
//
//  Created by Boris Barac on 25/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation

struct StreamPostBody: Codable {
    let audio_language = "SPA"
    let audio_quality = "2.0"
    let content_id: String
    let content_type = "movies"
    let device_serial = "AABBCCDDCC112233"
    let device_stream_video_quality = "FHD"
    let player = "ios:PD-NONE"
    let subtitle_language = "MIS"
    let video_type = "trailer"
}
