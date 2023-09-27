Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2, 
             "244701557301-te49kcc8gn8bjsvg15rtsf3ulf3pofh9.apps.googleusercontent.com",
             "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"
end