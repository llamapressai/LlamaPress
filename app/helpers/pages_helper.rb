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
<!DOCTYPE html><html lang="en"><head data-llama-id="0">
    <meta charset="UTF-8" data-llama-id="1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" data-llama-id="2">
    <title data-llama-id="3">LlamaPress - Build Webpages with a Chatbot</title>
    <link rel="icon" type="image/png" href="https://service-jobs-images.s3.us-east-2.amazonaws.com/7rl98t1weu387r43il97h6ipk1l7" data-llama-id="4">
    <script src="https://cdn.tailwindcss.com" data-llama-id="5"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&amp;display=swap" rel="stylesheet" data-llama-id="6">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" data-llama-id="7">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet" data-llama-id="8">
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js" data-llama-id="9"></script>
    <style data-llama-id="10">
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
<body class="bg-gray-100" data-llama-id="11" data-aos-easing="ease" data-aos-duration="1000" data-aos-delay="0">
    <header class="gradient-bg text-white py-16" data-llama-id="12">
        <div class="container mx-auto text-center" data-llama-id="13">
            <br data-llama-id="14">
            <h1 class="text-5xl font-bold mb-4 aos-init aos-animate" data-aos="fade-up" data-aos-delay="200" data-llama-id="15">&nbsp;LlamaPress Tutorial&nbsp;<span style="font-size: 3rem; background-color: initial; color: rgb(255 255 255 / var(--tw-text-opacity));" data-llama-id="16">🦙</span></h1><div data-llama-id="17">You are viewing an editable LlamaPress Page.</div></div></header>

    <main class="container mx-auto px-4 py-16" data-llama-id="18">
        <section id="tutorial" class="bg-white rounded-lg shadow-lg p-8 mb-12 aos-init aos-animate" data-aos="fade-up" data-llama-id="19">
            <h2 class="text-3xl font-bold mb-8 text-center" data-llama-id="20">How to Use LlamaPress: Step-by-Step Tutorial</h2>
            <ol class="space-y-6" data-llama-id="21">
                <li class="flex items-start" data-llama-id="22">
                    <div class="flex-shrink-0" data-llama-id="23">
                        <div class="w-12 h-12 md:w-16 md:h-16 bg-blue-500 rounded-full flex items-center justify-center cursor-pointer" data-llama="app/views/shared/_chat.html.erb" data-llama-id="24">
                            <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/7rl98t1weu387r43il97h6ipk1l7" alt="LlamaPress Logo" class="h-8 w-8 md:h-12 md:w-12 llama-prevent-img-resize" data-llama="app/views/shared/_chat.html.erb" data-llama-id="25">
                        </div>
                    </div>
                    <div class="ml-4" data-llama-id="26">
                        <h3 class="text-2xl font-semibold mb-2" data-llama-id="27">1. Click on our Chatbot (LlamaBot)</h3>
                        <p class="text-gray-700" data-llama-id="28">Locate the LlamaBot icon at the bottom right corner of your screen and click on it to open the chat window.</p>
                    </div>
                </li>
                <li class="flex items-start" data-llama-id="29">
                    <div class="flex-shrink-0" data-llama-id="30">
                        <div class="feature-icon bg-green-600" data-llama-id="31">
                            <i class="fas fa-question" data-llama-id="32"></i>
                        </div>
                    </div>
                    <div class="ml-4" data-llama-id="33">
                        <h3 class="text-2xl font-semibold mb-2" data-llama-id="34">2. Ask LlamaBot for Changes</h3>
                        <p class="text-gray-700" data-llama-id="35">Type in the changes you want to implement on your page and let LlamaBot assist you with the modifications.</p>
                    </div>
                </li>
                <li class="flex items-start" data-llama-id="36">
                    <div class="flex-shrink-0" data-llama-id="37">
                        <div class="feature-icon bg-yellow-600" data-llama-id="38">
                            <i class="fas fa-mouse-pointer" data-llama-id="39"></i>
                        </div>
                    </div>
                    <div class="ml-4" data-llama-id="40">
                        <h3 class="text-2xl font-semibold mb-2" data-llama-id="41">3. Use the Pointing Tool</h3>
                        <p class="text-gray-700" data-llama-id="42">Click on the pointing tool to select a specific element you wish to change, then instruct LlamaBot to make the desired modifications.</p>
                    </div>
                </li>
                <li class="flex items-start" data-llama-id="43">
                    <div class="flex-shrink-0" data-llama-id="44">
                        <div class="feature-icon bg-red-600" data-llama-id="45">
                            <i class="fas fa-keyboard" data-llama-id="46"></i>
                        </div>
                    </div>
                    <div class="ml-4" data-llama-id="47">
                        <h3 class="text-2xl font-semibold mb-2" data-llama-id="48">4. Keyboard Shortcuts</h3>
                        <ul class="list-disc list-inside text-gray-700" data-llama-id="49">
                            <li data-llama-id="50"><span class="font-semibold" data-llama-id="51">Escape Key:</span> Open the LlamaBot window.</li>
                            <li data-llama-id="52"><span class="font-semibold" data-llama-id="53">CMD + L:</span> Copy the selected element to the chat window.</li>
                            <li data-llama-id="54"><span class="font-semibold" data-llama-id="55">Option + C:</span> Toggle the Pointing Tool.</li>
                            <li data-llama-id="56"><span class="font-semibold" data-llama-id="57">Ctrl + Z:</span> Undo the last change made by LlamaBot.</li>
                            <li data-llama-id="58"><span class="font-semibold" data-llama-id="59">Ctrl + Shift + Z:</span> Redo the last change from LlamaBot.</li>
                            <li data-llama-id="60"><span class="font-semibold" data-llama-id="61">Shift + Enter:</span> Create a new line in the chat window.</li>
                        </ul>
                    </div>
                </li>
                <li class="flex items-start" data-llama-id="62">
                    <div class="flex-shrink-0" data-llama-id="63">
                        <div class="feature-icon bg-purple-600" data-llama-id="64">
                            <i class="fas fa-undo" data-llama-id="65"></i>
                        </div>
                    </div>
                    <div class="ml-4" data-llama-id="66">
                        <h3 class="text-2xl font-semibold mb-2" data-llama-id="67">5. Undo and Redo Changes</h3>
                        <p class="text-gray-700" data-llama-id="68">Easily revert or reapply changes using the keyboard shortcuts to maintain full control over your website's appearance.</p>
                    </div>
                </li>
                <li class="flex items-start" data-llama-id="69">
                    <div class="flex-shrink-0" data-llama-id="70">
                        <div class="feature-icon bg-pink-600" data-llama-id="71">
                            <i class="fas fa-code" data-llama-id="72"></i>
                        </div>
                    </div>
                    <div class="ml-4" data-llama-id="73">
                        <h3 class="text-2xl font-semibold mb-2" data-llama-id="74">6. Advanced Customization</h3>
                        <p class="text-gray-700" data-llama-id="75">Use keyboard shortcuts in combination with LlamaBot to perform advanced customizations and streamline your workflow.</p>
                    </div>
                </li>
                <li class="flex items-start" data-llama-id="76">
                    <div class="flex-shrink-0" data-llama-id="77">
                        <div class="feature-icon bg-indigo-600" data-llama-id="78">
                            <i class="fas fa-terminal" data-llama-id="79"></i>
                        </div>
                    </div>
                    <div class="ml-4" data-llama-id="80">
                        <h3 class="text-2xl font-semibold mb-2" data-llama-id="81">7. Efficient Workflow</h3>
                        <p class="text-gray-700" data-llama-id="82">Utilize the provided shortcuts and tools to create a seamless and efficient workflow, allowing you to focus on growing your business.</p>
                    </div>
                </li>
            </ol>
        </section>
    </main>

    <footer class="gradient-bg text-white py-8" data-llama-id="83">
        <div class="container mx-auto text-center" data-llama-id="84">
            <span class="text-xl font-semibold" data-llama-id="85">Built with LlamaPress</span>
            <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/7rl98t1weu387r43il97h6ipk1l7" alt="LlamaPress Logo" class="inline-block ml-4 h-10" data-llama-id="86">
        </div>
    </footer>

    <script data-llama-id="87">
        AOS.init({
            duration: 1000,
            once: true,
        });
    </script></body></html>
        HTML
    end
end