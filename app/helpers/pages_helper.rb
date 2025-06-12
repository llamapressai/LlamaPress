module PagesHelper

    def self.get_starting_templates
        # get html content from each file in templates folder
        templates = Dir.glob(Rails.root.join('app', 'views', 'llama_bot', 'templates', '*.html*')).map do |file|
            {
                url:  "/llama_bot/templates/" + file.split('/').last.chomp('.html'),
                name: file.split('/').last.chomp('.html'),
                content: File.read(file)
            }
        end
        return templates
    end

    def self.starting_html_content
        <<~HTML
        <!DOCTYPE html><html lang="en">
            <head data-llama-editable="true" data-llama-id="0">
                <meta content="width=device-width, initial-scale=1.0" name="viewport">
                <script src="https://cdn.tailwindcss.com"></script>
                <link data-llama-editable="true" data-llama-id="7" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
            </head>
            <body>
                Hello, world!
            </body>
        </html>
        HTML
    end

    def self.starting_html_content_for_picture_to_html
        <<~HTML
        <!DOCTYPE html><html lang="en"><head data-llama-editable="true" data-llama-id="0">
        <meta charset="utf-8" data-llama-editable="true" data-llama-id="1">
        <meta content="width=device-width, initial-scale=1.0" data-llama-editable="true" data-llama-id="2" name="viewport">
        <title data-llama-editable="true" data-llama-id="3">LlamaPress - Build Webpages with a Chatbot</title>
        <link data-llama-editable="true" data-llama-id="4" href="https://service-jobs-images.s3.us-east-2.amazonaws.com/7rl98t1weu387r43il97h6ipk1l7" rel="icon" type="image/png">
        <script data-llama-editable="true" data-llama-id="5" src="https://cdn.tailwindcss.com"></script>
        <link data-llama-editable="true" data-llama-id="6" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&amp;display=swap" rel="stylesheet">
        <link data-llama-editable="true" data-llama-id="7" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link data-llama-editable="true" data-llama-id="8" href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
        <script data-llama-editable="true" data-llama-id="9" src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <style data-llama-editable="true" data-llama-id="10">
                body {
                    font-family: 'Poppins', sans-serif;
                }
                .gradient-bg {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                }
                .feature-icon {
                    width: 48px;
                    height: 48px;
                    font-size: 24px;
                    background-color: #667eea;
                    color: white;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin-bottom: 1rem;
                }
            </style>
        </head>
        <body class="bg-gray-100" data-aos-delay="0" data-aos-duration="1000" data-aos-easing="ease" data-llama-editable="true" data-llama-id="12" data-llama-ids="11">
        <main class="container mx-auto px-4 py-16" data-llama-editable="true" data-llama-id="13"><section class="bg-white rounded-lg shadow-lg p-8 mb-12 aos-init aos-animate" data-aos="fade-up" data-llama-editable="true" data-llama-id="14">
        <div class="flex flex-col items-center" data-llama-editable="true" data-llama-id="15">
        <div class="mb-4 flex flex-col items-start" data-llama-editable="true" data-llama-id="16">
        <svg class="animate-spin h-8 w-8 text-blue-500" data-llama-editable="true" data-llama-id="17" fill="none" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
        <circle class="opacity-25" cx="12" cy="12" data-llama-editable="true" data-llama-id="18" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" data-llama-editable="true" data-llama-id="19" fill="currentColor"></path>
        </svg>
        <span class="mt-2 text-blue-500 font-medium" data-llama-editable="true" data-llama-id="20">Building Your Page..</span><span class="mt-2 text-blue-500 font-medium" data-llama-editable="true" data-llama-id="21">Page will automatically refresh once completed</span>
        </div>
        <img class="h-464 w-528 h-468" data-llama-editable="true" data-llama-id="22" src="https://llamapress-ai-image-uploads.s3.us-west-2.amazonaws.com/iw29lao3g5m8dfczo9dq5umkrhvg" style="width: 526px; height: 469.643px;">
        <br data-llama-editable="true" data-llama-id="23">
        </div>
        </section>
        </main>
        <script data-llama-editable="true" data-llama-id="24">
                AOS.init({
                    duration: 1000,
                    once: true,
                });
            </script>
        </body></html>
        HTML
    end
end