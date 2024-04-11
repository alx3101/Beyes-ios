//
//  SupabaseServices.swift
//  Beyes
//
//  Created by Alex Popa on 30/03/24.
//

import Foundation
import Supabase

class SupabaseServices {
    let client: SupabaseClient

    init() {
        client = SupabaseClient(supabaseURL: URL(string: "https://lgzbvhbuwfjrzvkwgjji.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxnemJ2aGJ1d2Zqcnp2a3dnamppIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTY5NjgxNDYsImV4cCI6MjAxMjU0NDE0Nn0.P3Xfy0eAASnxrdUIWw0Gmf1rdAFumkzRVqBVtT6oE9A")
    }
}
