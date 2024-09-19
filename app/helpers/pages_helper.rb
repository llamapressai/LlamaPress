module PagesHelper
    def self.starting_html_content
        <<~HTML
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Llama Press - Build Anything with AI</title>
                <link rel="icon" type="image/png" href="https://service-jobs-images.s3.us-east-2.amazonaws.com/7rl98t1weu387r43il97h6ipk1l7">
                <script src="https://cdn.tailwindcss.com"></script>
                <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <style>
                    body {
                        font-family: 'Poppins', sans-serif;
                    }
                    .footer-banner {
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        background-color: #4a4a4a;
                        color: white;
                        padding: 20px;
                        /* position: absolute; */
                        bottom: 0;
                        width: 100%;
                        box-shadow: 0 -4px 6px rgba(0, 0, 0, 0.1);
                    }
                    .footer-text {
                        font-size: 18px;
                        font-weight: bold;
                    }
                    .feature-icon {
                        width: 24px;
                        height: 24px;
                        font-size: 24px;
                    }
                </style>
                <script type="text/javascript">
                    (function(c,l,a,r,i,t,y){
                        c[a]=c[a]||function(){(c[a].q=c[a].q||[]).push(arguments)};
                        t=l.createElement(r);t.async=1;t.src="https://www.clarity.ms/tag/"+i;
                        y=l.getElementsByTagName(r)[0];y.parentNode.insertBefore(t,y);
                    })(window, document, "clarity", "script", "nrbh04rpga");
                </script>    
            </head>
            <body class="bg-gray-100">
                <header class="bg-gray-100 py-4">
                    <div class="container mx-auto text-center">
                        <!-- <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/iwe9n1t0842nqmfi7jzg96h2dzrz" alt="LlamaBergPress Logo" class="h-80 mx-auto"> -->
                        <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/7rl98t1weu387r43il97h6ipk1l7" alt="LlamaBergPress Logo" class="h-80 mx-auto">

                        
                    </div>
                </header>

                <main class="container mx-auto px-4 py-8">
                    <h1 class="text-4xl font-bold text-center mb-2">LLamaPress</h1>
                    <h2 class="text-2xl text-center text-gray-600 mb-4">An Open Sourced SaaS Builder for Non-Technical Builders</h2>

                    <article class="bg-white rounded-lg shadow-lg p-8 mb-8">
                        <h3 class="text-2xl font-bold mb-4">Why Open Source?</h3>
                        
                        <h4 class="text-xl font-semibold mb-2">Economic/Market Reasons</h4>
                        <p class="mb-4">Costs to develop software are going to 0. This is because of Open Source and LLMs. We're going to beat everyone there by combining an open source CRM/CMS with LLMs.</p>
                        
                        <h4 class="text-xl font-semibold mb-2">User-Centric Reasons</h4>
                        <ul class="list-disc list-inside mb-4">
                            <li>Freedom and Control</li>
                            <li>Privacy</li>
                            <li>Community Driven Innovation and Collaboration</li>
                            <li>Cost Savings</li>
                            <li>Security</li>
                            <li>Customizability and Flexibility</li>
                        </ul>
                        
                        <h4 class="text-xl font-semibold mb-2">Strategic Reasons</h4>
                        <p class="mb-4">Deep Network Effects when people build plugins on top of your open source ecosystem (like WordPress).</p>
                    </article>

                    <article class="bg-white rounded-lg shadow-lg p-8 mb-8">
                        <h3 class="text-2xl font-bold mb-4">Why Ruby on Rails?</h3>
                        <ul class="list-disc list-inside mb-4">
                            <li>Strong Open Source Community, Historic Popularity, and High Quality Documentation</li>
                            <li>Rails is Optimized for the Developer Experience, Which Means It's Optimized for LLMs to Understand It</li>
                        </ul>
                        
                        <h3 class="text-2xl font-bold mb-4">Our Philosophy</h3>
                        <p class="mb-4">Ruby on Rails is unequivocally the most superior framework for LLM code generation, bar none. Its design philosophy and features make it the perfect match for AI-driven development:</p>
                        
                        <div class="grid md:grid-cols-2 gap-6">
                            <div class="flex items-start">
                                <i class="fas fa-bolt mr-4 text-indigo-600 feature-icon"></i>
                                <div>
                                    <h4 class="font-semibold mb-2">Reduced Token Usage</h4>
                                    <p class="text-gray-700">Rails' "convention over configuration" principle and Ruby's expressive syntax results in dramatically reduced code verbosity. Fewer tokens allows the LLM to "see" more of the code or context at once.</p>
                                </div>
                            </div>
                            <div class="flex items-start">
                                <i class="fas fa-book-open mr-4 text-indigo-600 feature-icon"></i>
                                <div>
                                    <h4 class="font-semibold mb-2">Semantic Clarity</h4>
                                    <p class="text-gray-700">Ruby's natural language-like syntax aligns perfectly with LLMs' language understanding capabilities. </p>
                                </div>
                            </div>
                            <div class="flex items-start">
                                <i class="fas fa-forward mr-4 text-indigo-600 feature-icon"></i>
                                <div>
                                    <h4 class="font-semibold mb-2">Rapid Prototyping</h4>
                                    <p class="text-gray-700">Rails' scaffolding and generator tools are tailor-made for quick iterations - a crucial advantage when working with LLMs.</p>
                                </div>
                            </div>
                            <div class="flex items-start">
                                <i class="fas fa-check-circle mr-4 text-indigo-600 feature-icon"></i>
                                <div>
                                    <h4 class="font-semibold mb-2">Built-in Best Practices</h4>
                                    <p class="text-gray-700">Rails' opinionated nature embeds industry best practices into its core. This frees up the LLM to focus on higher level abstractions, rather than getting bogged down in non-standard implementations</p>
                                </div>
                            </div>
                            <div class="flex items-start">
                                <i class="fas fa-box mr-4 text-indigo-600 feature-icon"></i>
                                <div>
                                    <h4 class="font-semibold mb-2">Comprehensive Ecosystem</h4>
                                    <p class="text-gray-700">The vast Ruby gems ecosystem provides a rich set of pre-built solutions.</p>
                                </div>
                            </div>
                            <div class="flex items-start">
                                <i class="fas fa-database mr-4 text-indigo-600 feature-icon"></i>
                                <div>
                                    <h4 class="font-semibold mb-2">Database Abstraction</h4>
                                    <p class="text-gray-700">ActiveRecord's powerful ORM capabilities allow LLMs to generate database interactions without getting bogged down in SQL specifics.</p>
                                </div>
                            </div>
                            <div class="flex items-start">
                                <i class="fas fa-check-square mr-4 text-indigo-600 feature-icon"></i>
                                <div>
                                    <h4 class="font-semibold mb-2">Testing Framework</h4>
                                    <p class="text-gray-700">Rails' integrated testing framework allows LLMs to simultaneously generate application code and corresponding tests.</p>
                                </div>
                            </div>
                            <div class="flex items-start">
                                <i class="fas fa-layer-group mr-4 text-indigo-600 feature-icon"></i>
                                <div>
                                    <h4 class="font-semibold mb-2">RESTful Architecture</h4>
                                    <p class="text-gray-700">Rails' built-in support for RESTful design principles enables LLMs to generate well-structured, scalable APIs effortlessly.</p>
                                </div>
                            </div>
                            <div class="flex items-start">
                                <i class="fas fa-code mr-4 text-indigo-600 feature-icon"></i>
                                <div>
                                    <h4 class="font-semibold mb-2">Full-stack Capability</h4>
                                    <p class="text-gray-700">Rails' full-stack nature allows LLMs to generate cohesive, end-to-end solutions within a single framework.</p>
                                </div>
                            </div>
                            <div class="flex items-start">
                                <i class="fas fa-users mr-4 text-indigo-600 feature-icon"></i>
                                <div>
                                    <h4 class="font-semibold mb-2">Community and Documentation</h4>
                                    <p class="text-gray-700">The extensive Rails community and documentation serve as a rich knowledge base for LLMs.</p>
                                </div>
                            </div>
                            <div class="flex items-start">
                                <i class="fas fa-cogs mr-4 text-indigo-600 feature-icon"></i>
                                <div>
                                    <h4 class="font-semibold mb-2">Metaprogramming</h4>
                                    <p class="text-gray-700">Ruby's powerful metaprogramming capabilities enable LLMs to generate highly dynamic and adaptable code.</p>
                                </div>
                            </div>
                        </div>

                        <div class="mt-8">
                            <h4 class="text-xl font-semibold mb-4">In Conclusion</h4>
                            <p class="text-gray-700">Ruby on Rails isn't just a good choice for LLM code generation - it's the optimal choice. Its concise syntax, semantic clarity, and robust ecosystem create a synergy with AI that no other framework can match. As we move further into the age of AI-assisted development, Ruby on Rails stands out as the framework that will unlock the full potential of LLM-driven coding, revolutionizing the way we build and scale applications. Any other choice is simply settling for less.</p>
                        </div>
                    </article>

                    <article class="bg-white rounded-lg shadow-lg p-8 mb-8">
                        <h3 class="text-2xl font-bold mb-4">How Do We Make Money?</h3>
                        <p class="mb-4">We cater to less-technical users who need help building customizable software for cheap:</p>
                        <ul class="list-disc list-inside mb-4">
                            <li>Hosting & Deployment</li>
                            <li>Support</li>
                            <li>Users Who Need Deeper Custom Development</li>
                            <li>A Marketplace for Plugins to Extend LlamaPress</li>
                        </ul>
                    </article>

                    <article class="bg-white rounded-lg shadow-lg p-8 mb-8">
                        <h3 class="text-2xl font-bold mb-4">What's Not Open Sourced?</h3>
                        <p class="mb-4">Our Expert AI Agent, LlamaBot, that is Trained to be Your Expert CTO. LlamaBot is a Highly Opinionated Ruby on Rails and LlamaPress Expert. LlamaBot guides you through any LLamaPress project, and even acts as your very own custom software developer.</p>
                        <p>Even the most non-technical users can still build their own customized software solution on top of LlamaPress, using LlamaBot.</p>
                    </article>

                    <article class="bg-white rounded-lg shadow-lg p-8 mb-8">
                        <h3 class="text-2xl font-bold mb-4">Our Vision</h3>
                        <p class="mb-4">LlamaPress is optimized for end-to-end user experience — from the Least Technical User to the Most Technical.</p>
                        <!-- <p class="font-bold">This is our Billion Dollar Vision.</p> -->
                    </article>

                    <article class="bg-white rounded-lg shadow-lg p-8 mb-8">
                        <h3 class="text-2xl font-bold mb-4">Current State of Affairs: GTM</h3>
                        <ul class="list-disc list-inside mb-4">
                            <li>Our GTM is that we continue to use LlamaPress to build out our SaaS and marketing agency, along with helping new users build their own software on top of LlamaPress.</li>
                            <li>Our origin story: we had a massive problem with our own SaaS Startup/Agency.</li>
                        </ul>
                    </article>

                    <article class="bg-white rounded-lg shadow-lg p-8 mb-8">
                        <h3 class="text-2xl font-bold mb-4">Llama Press was built to solve a massive problem we had with our own SaaS Startup/Agency</h3>
                        <ol class="list-decimal list-inside mb-4">
                            <li>Users needed customizations and new features all the time.</li>
                            <li>Building these features for users was conflicted. One user wants A, the other wants B.</li>
                            <li>Each company was slightly different. They'd want slightly different configurations and things.</li>
                            <li>Support was way too expensive, especially given many of their price points.</li>
                            <li>We built in a chat bot for our freemium tier users to interact with for support.</li>
                            <li>We began building in LLMs to take their requests and create a game plan for implementation.</li>
                            <li>We started letting the ChatBot implement changes under our supervision.</li>
                            <li>We found it was surprisingly good! And we realized it was because the code we were modifying was built on top of Ruby on Rails.</li>
                        </ol>
                        <!-- <p class="font-bold">We realized we have a billion dollar market opportunity in front of us.</p> -->
                    </article>
                </main>

                <footer class="footer-banner">
                    <div class="container mx-auto text-center">
                        <!-- <p class="inline-block">Built with LlamaPress</p> -->
                        <span class="footer-text">Built with LlamaPress</span>
                        <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/7rl98t1weu387r43il97h6ipk1l7" alt="LlamaPress Logo" class="inline-block mr-2 h-14">
                    </div>
                </footer>
            </body>
            </html>   
        HTML
        # <<~HTML
        # <!DOCTYPE html>
        # <html lang="en">
        # <head>
        #     <meta charset="UTF-8">
        #     <meta name="viewport" content="width=device-width, initial-scale=1.0">
        #     <title>Soma School of Massage</title>
        #     <link rel="icon" type="image/x-icon" href="https://service-jobs-images.s3.us-east-2.amazonaws.com/meyl72n3jsng1oic20xiavu5ipjs">
        #     <script src="https://cdn.tailwindcss.com"></script>
        #     <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        #     <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
        # </head>
        # <body class="bg-gray-100 font-sans">
        #     <header class="bg-white shadow-md">
        #         <nav class="container mx-auto px-6 py-3 flex justify-between items-center">
        #             <div class="flex items-center">
        #                 <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/meyl72n3jsng1oic20xiavu5ipjs" alt="Soma Massage Logo" class="h-24 w-auto mr-3">
        #                 <a href="#" class="text-2xl font-bold text-indigo-600">Soma Massage</a>
        #             </div>
        #             <ul class="flex space-x-6">
        #                 <li><a href="#" class="text-gray-700 hover:text-indigo-600">Home</a></li>
        #                 <li><a href="#" class="text-gray-700 hover:text-indigo-600">Courses</a></li>
        #                 <li><a href="#" class="text-gray-700 hover:text-indigo-600">About</a></li>
        #                 <li><a href="#" class="text-gray-700 hover:text-indigo-600">Contact</a></li>
        #             </ul>
        #         </nav>
        #     </header>
        
        #     <main>
        #         <section class="bg-indigo-600 text-white py-20">
        #             <div class="container mx-auto px-6 text-center">
        #                 <h1 class="text-5xl font-bold mb-4" data-aos="fade-up">Welcome to Soma School of Massage</h1>
        #                 <p class="text-xl mb-8" data-aos="fade-up" data-aos-delay="200">Discover the art of healing through touch</p>
        #                 <a href="#" class="bg-white text-indigo-600 py-2 px-6 rounded-full text-lg font-semibold hover:bg-indigo-100 transition duration-300" data-aos="fade-up" data-aos-delay="400">Enroll Now</a>
        #             </div>
        #         </section>
        
        #         <section class="py-20">
        #             <div class="container mx-auto px-6">
        #                 <h2 class="text-3xl font-bold text-center mb-8" data-aos="fade-up">Our Courses</h2>
        #                 <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
        #                     <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up">
        #                         <i class="fas fa-hands text-4xl text-indigo-600 mb-4"></i>
        #                         <h3 class="text-xl font-semibold mb-2">Swedish Massage</h3>
        #                         <p class="text-gray-600">Learn the fundamentals of relaxation massage techniques.</p>
        #                     </div>
        #                     <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up" data-aos-delay="200">
        #                         <i class="fas fa-spa text-4xl text-indigo-600 mb-4"></i>
        #                         <h3 class="text-xl font-semibold mb-2">Deep Tissue Massage</h3>
        #                         <p class="text-gray-600">Master the art of addressing chronic muscle tension.</p>
        #                     </div>
        #                     <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up" data-aos-delay="400">
        #                         <i class="fas fa-heartbeat text-4xl text-indigo-600 mb-4"></i>
        #                         <h3 class="text-xl font-semibold mb-2">Sports Massage</h3>
        #                         <p class="text-gray-600">Specialize in techniques for athletes and active individuals.</p>
        #                     </div>
        #                 </div>
        #             </div>
        #         </section>
        
        #         <section class="bg-gray-200 py-20">
        #             <div class="container mx-auto px-6">
        #                 <div class="flex flex-col md:flex-row items-center">
        #                     <div class="md:w-1/2 mb-8 md:mb-0 flex justify-center" data-aos="fade-right">
        #                         <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/ptfv92jnbogpfvld8eharmsch84m" alt="Massage training" class="rounded-lg shadow-md max-h-96 object-cover">
        #                     </div>
        #                     <div class="md:w-1/2 md:pl-12" data-aos="fade-left">
        #                         <h2 class="text-3xl font-bold mb-4">Why Choose Soma Massage School?</h2>
        #                         <ul class="space-y-4">
        #                             <li class="flex items-center">
        #                                 <i class="fas fa-check-circle text-indigo-600 mr-2"></i>
        #                                 <span>Expert instructors with years of experience</span>
        #                             </li>
        #                             <li class="flex items-center">
        #                                 <i class="fas fa-check-circle text-indigo-600 mr-2"></i>
        #                                 <span>State-of-the-art facilities and equipment</span>
        #                             </li>
        #                             <li class="flex items-center">
        #                                 <i class="fas fa-check-circle text-indigo-600 mr-2"></i>
        #                                 <span>Comprehensive curriculum covering various modalities</span>
        #                             </li>
        #                             <li class="flex items-center">
        #                                 <i class="fas fa-check-circle text-indigo-600 mr-2"></i>
        #                                 <span>Flexible class schedules to fit your lifestyle</span>
        #                             </li>
        #                         </ul>
        #                     </div>
        #                 </div>
        #             </div>
        #         </section>
        
        #         <section class="py-20 bg-gray-100">
        #             <div class="container mx-auto px-6">
        #                 <h2 class="text-3xl font-bold text-center mb-8" data-aos="fade-up">Our Location</h2>
        #                 <div class="flex flex-col md:flex-row items-center">
        #                     <div class="md:w-1/2 mb-8 md:mb-0" data-aos="fade-right">
        #                         <h3 class="text-2xl font-semibold mb-4">Serving Centerville and Bountiful, Utah</h3>
        #                         <p class="text-gray-600 mb-4">Soma Massage School is proudly located in the heart of Centerville, Utah, just minutes away from beautiful Bountiful. Our prime location allows us to serve students from both communities and the surrounding areas.</p>
        #                         <p class="text-gray-600 mb-4">Centerville and Bountiful offer a perfect blend of small-town charm and modern amenities, providing an ideal environment for learning and growth. With stunning views of the Wasatch Mountains and easy access to outdoor recreation, our students can find inspiration and relaxation beyond the classroom.</p>
        #                     </div>
        #                     <div class="md:w-1/2 md:pl-12" data-aos="fade-left">
        #                         <img src="https://picsum.photos/800/600" alt="Centerville, Utah" class="rounded-lg shadow-md">
        #                     </div>
        #                 </div>
        #             </div>
        #         </section>
        
        #         <section class="py-20">
        #             <div class="container mx-auto px-6">
        #                 <h2 class="text-3xl font-bold text-center mb-8" data-aos="fade-up">Meet Our Founder: Kim Kendall</h2>
        #                 <div class="flex flex-col md:flex-row items-center">
        #                     <div class="md:w-1/3 mb-8 md:mb-0" data-aos="fade-right">
        #                         <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/dwhvk6dflfdxgl3loja6tb676fcc" alt="Kim Kendall" class="rounded-full shadow-md mx-auto">
        #                     </div>
        #                     <div class="md:w-2/3 md:pl-12" data-aos="fade-left">
        #                         <h3 class="text-2xl font-semibold mb-4">Kim Kendall: Experienced Educator and Practitioner</h3>
        #                         <p class="text-gray-600 mb-4">Kim Kendall brings a wealth of experience to Soma Massage School. With over 15 years in the massage therapy industry, Kim has dedicated her career to both practicing and teaching the art of healing touch.</p>
        #                         <p class="text-gray-600 mb-4">Before founding Soma Massage School, Kim honed her teaching skills at the prestigious Renaissance Massage School. There, she developed a reputation for her engaging teaching style and ability to break down complex techniques into easily understandable components.</p>
        #                         <p class="text-gray-600 mb-4">In addition to her teaching experience, Kim has worked extensively as a massage therapist at Hand and Stone in Bountiful, UT. This hands-on experience in a professional setting allows her to bring real-world insights to her students, preparing them for successful careers in massage therapy.</p>
        #                     </div>
        #                 </div>
        #             </div>
        #         </section>
        
        #         <section class="bg-indigo-100 py-20">
        #             <div class="container mx-auto px-6">
        #                 <h2 class="text-3xl font-bold text-center mb-8" data-aos="fade-up">Kim's Approach to Massage Education</h2>
        #                 <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
        #                     <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up">
        #                         <h3 class="text-xl font-semibold mb-2">Holistic Learning</h3>
        #                         <p class="text-gray-600">Kim believes in teaching massage therapy as a holistic practice, emphasizing the connection between body, mind, and spirit.</p>
        #                     </div>
        #                     <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up" data-aos-delay="200">
        #                         <h3 class="text-xl font-semibold mb-2">Practical Experience</h3>
        #                         <p class="text-gray-600">Drawing from her work at Hand and Stone, Kim ensures students gain practical, industry-relevant skills.</p>
        #                     </div>
        #                     <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up" data-aos-delay="400">
        #                         <h3 class="text-xl font-semibold mb-2">Personalized Attention</h3>
        #                         <p class="text-gray-600">Kim's teaching style focuses on individual growth, providing personalized feedback and support to each student.</p>
        #                     </div>
        #                     <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up" data-aos-delay="600">
        #                         <h3 class="text-xl font-semibold mb-2">Continuous Learning</h3>
        #                         <p class="text-gray-600">Kim encourages students to view massage therapy as a lifelong learning journey, always seeking to improve and grow.</p>
        #                     </div>
        #                 </div>
        #             </div>
        #         </section>
        
        #         <section class="py-20 bg-gray-100">
        #             <div class="container mx-auto px-6">
        #                 <h2 class="text-3xl font-bold text-center mb-8" data-aos="fade-up">Our School Gallery</h2>
        #                 <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
        #                     <div class="overflow-hidden rounded-lg shadow-md" data-aos="fade-up">
        #                         <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/dmh98utu5ur2h9r0iz51zxv3auv7" alt="Massage School Image 1" class="w-full h-64 object-cover transition duration-300 ease-in-out transform hover:scale-110">
        #                     </div>
        #                     <div class="overflow-hidden rounded-lg shadow-md" data-aos="fade-up" data-aos-delay="100">
        #                         <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/4l5ebd63nbe6tooq1xjsvo6b6r5i" alt="Massage School Image 2" class="w-full h-64 object-cover transition duration-300 ease-in-out transform hover:scale-110">
        #                     </div>
        #                     <div class="overflow-hidden rounded-lg shadow-md" data-aos="fade-up" data-aos-delay="200">
        #                         <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/t0djj7kafnvuj6ycv7k9d6vw1azg" alt="Massage School Image 3" class="w-full h-64 object-cover transition duration-300 ease-in-out transform hover:scale-110">
        #                     </div>
        #                     <div class="overflow-hidden rounded-lg shadow-md" data-aos="fade-up" data-aos-delay="300">
        #                         <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/fn74osxs5k6ajl5umnwwgrxzh4rq" alt="Massage School Image 4" class="w-full h-64 object-cover transition duration-300 ease-in-out transform hover:scale-110">
        #                     </div>
        #                     <div class="overflow-hidden rounded-lg shadow-md" data-aos="fade-up" data-aos-delay="400">
        #                         <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/j7m60gyahdfesgh0aj7h6fzmay75" alt="Massage School Image 5" class="w-full h-64 object-cover transition duration-300 ease-in-out transform hover:scale-110">
        #                     </div>
        #                     <div class="overflow-hidden rounded-lg shadow-md" data-aos="fade-up" data-aos-delay="500">
        #                         <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/1x278wzhcpaaenqf9nkliapwyi9z" alt="Massage School Image 6" class="w-full h-64 object-cover transition duration-300 ease-in-out transform hover:scale-110">
        #                     </div>
        #                     <div class="overflow-hidden rounded-lg shadow-md" data-aos="fade-up" data-aos-delay="600">
        #                         <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/ki5y1gpkiain4xt6hhfknb6h898g" alt="Massage School Image 7" class="w-full h-64 object-cover transition duration-300 ease-in-out transform hover:scale-110">
        #                     </div>
        #                     <div class="overflow-hidden rounded-lg shadow-md" data-aos="fade-up" data-aos-delay="700">
        #                         <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/atnvojbw5ueg6nelzx27b7t9wzp7" alt="Massage School Image 8" class="w-full h-64 object-cover transition duration-300 ease-in-out transform hover:scale-110">
        #                     </div>
        #                 </div>
        #             </div>
        #         </section>
        
        #         <section class="py-20">
        #             <div class="container mx-auto px-6 text-center">
        #                 <h2 class="text-3xl font-bold mb-8" data-aos="fade-up">What Our Students Say</h2>
        #                 <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
        #                     <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up">
        #                         <img src="https://picsum.photos/100" alt="Student 1" class="rounded-full w-24 h-24 mx-auto mb-4">
        #                         <p class="text-gray-600 mb-4">"Soma Massage School changed my life. The instructors are amazing, and I feel confident in my skills."</p>
        #                         <p class="font-semibold">- Jane Doe</p>
        #                     </div>
        #                     <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up" data-aos-delay="200">
        #                         <img src="https://picsum.photos/101" alt="Student 2" class="rounded-full w-24 h-24 mx-auto mb-4">
        #                         <p class="text-gray-600 mb-4">"I couldn't be happier with my education at Soma. The hands-on experience was invaluable."</p>
        #                         <p class="font-semibold">- John Smith</p>
        #                     </div>
        #                     <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up" data-aos-delay="400">
        #                         <img src="https://picsum.photos/102" alt="Student 3" class="rounded-full w-24 h-24 mx-auto mb-4">
        #                         <p class="text-gray-600 mb-4">"The supportive community at Soma made learning enjoyable and helped me grow as a therapist."</p>
        #                         <p class="font-semibold">- Emily Johnson</p>
        #                     </div>
        #                 </div>
        #             </div>
        #         </section>
        
        #         <section class="bg-indigo-600 text-white py-20">
        #             <div class="container mx-auto px-6 text-center">
        #                 <h2 class="text-3xl font-bold mb-8" data-aos="fade-up">Ready to Start Your Journey?</h2>
        #                 <p class="text-xl mb-8" data-aos="fade-up" data-aos-delay="200">Enroll now and take the first step towards a rewarding career in massage therapy.</p>
        #                 <a href="#" class="bg-white text-indigo-600 py-2 px-6 rounded-full text-lg font-semibold hover:bg-indigo-100 transition duration-300" data-aos="fade-up" data-aos-delay="400">Apply Today</a>
        #             </div>
        #         </section>
        #     </main>
        
        #     <footer class="bg-gray-800 text-white py-8">
        #         <div class="container mx-auto px-6">
        #             <div class="flex flex-col md:flex-row justify-between items-center">
        #                 <div class="mb-4 md:mb-0">
        #                     <h3 class="text-2xl font-bold">Soma Massage School</h3>
        #                     <p class="text-gray-400">Empowering healers since 2005</p>
        #                 </div>
        #                 <div class="flex space-x-4">
        #                     <a href="#" class="text-gray-400 hover:text-white"><i class="fab fa-facebook-f"></i></a>
        #                     <a href="#" class="text-gray-400 hover:text-white"><i class="fab fa-instagram"></i></a>
        #                     <a href="#" class="text-gray-400 hover:text-white"><i class="fab fa-twitter"></i></a>
        #                     <a href="#" class="text-gray-400 hover:text-white"><i class="fab fa-linkedin-in"></i></a>
        #                 </div>
        #             </div>
        #             <hr class="border-gray-700 my-8">
        #             <div class="text-center text-gray-400">
        #                 <p>&copy; 2023 Soma Massage School. All rights reserved.</p>
        #             </div>
        #         </div>
        #     </footer>
        
        #     <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        #     <script>
        #         AOS.init({
        #             duration: 1000,
        #             once: true,
        #         });
        #     </script>
        # </body>
        # </html>
        #   HTML
    end
end
