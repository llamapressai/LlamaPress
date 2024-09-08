module StaticWebPagesHelper
    def self.starting_html_content
        <<~HTML
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Soma School of Massage</title>
            <link rel="icon" type="image/x-icon" href="https://service-jobs-images.s3.us-east-2.amazonaws.com/meyl72n3jsng1oic20xiavu5ipjs">
            <script src="https://cdn.tailwindcss.com"></script>
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
            <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
        </head>
        <body class="bg-gray-100 font-sans">
            <header class="bg-white shadow-md">
                <nav class="container mx-auto px-6 py-3 flex justify-between items-center">
                    <div class="flex items-center">
                        <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/meyl72n3jsng1oic20xiavu5ipjs" alt="Soma Massage Logo" class="h-24 w-auto mr-3">
                        <a href="#" class="text-2xl font-bold text-indigo-600">Soma Massage</a>
                    </div>
                    <ul class="flex space-x-6">
                        <li><a href="#" class="text-gray-700 hover:text-indigo-600">Home</a></li>
                        <li><a href="#" class="text-gray-700 hover:text-indigo-600">Courses</a></li>
                        <li><a href="#" class="text-gray-700 hover:text-indigo-600">About</a></li>
                        <li><a href="#" class="text-gray-700 hover:text-indigo-600">Contact</a></li>
                    </ul>
                </nav>
            </header>
        
            <main>
                <section class="bg-indigo-600 text-white py-20">
                    <div class="container mx-auto px-6 text-center">
                        <h1 class="text-5xl font-bold mb-4" data-aos="fade-up">Welcome to Soma School of Massage</h1>
                        <p class="text-xl mb-8" data-aos="fade-up" data-aos-delay="200">Discover the art of healing through touch</p>
                        <a href="#" class="bg-white text-indigo-600 py-2 px-6 rounded-full text-lg font-semibold hover:bg-indigo-100 transition duration-300" data-aos="fade-up" data-aos-delay="400">Enroll Now</a>
                    </div>
                </section>
        
                <section class="py-20">
                    <div class="container mx-auto px-6">
                        <h2 class="text-3xl font-bold text-center mb-8" data-aos="fade-up">Our Courses</h2>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                            <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up">
                                <i class="fas fa-hands text-4xl text-indigo-600 mb-4"></i>
                                <h3 class="text-xl font-semibold mb-2">Swedish Massage</h3>
                                <p class="text-gray-600">Learn the fundamentals of relaxation massage techniques.</p>
                            </div>
                            <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up" data-aos-delay="200">
                                <i class="fas fa-spa text-4xl text-indigo-600 mb-4"></i>
                                <h3 class="text-xl font-semibold mb-2">Deep Tissue Massage</h3>
                                <p class="text-gray-600">Master the art of addressing chronic muscle tension.</p>
                            </div>
                            <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up" data-aos-delay="400">
                                <i class="fas fa-heartbeat text-4xl text-indigo-600 mb-4"></i>
                                <h3 class="text-xl font-semibold mb-2">Sports Massage</h3>
                                <p class="text-gray-600">Specialize in techniques for athletes and active individuals.</p>
                            </div>
                        </div>
                    </div>
                </section>
        
                <section class="bg-gray-200 py-20">
                    <div class="container mx-auto px-6">
                        <div class="flex flex-col md:flex-row items-center">
                            <div class="md:w-1/2 mb-8 md:mb-0 flex justify-center" data-aos="fade-right">
                                <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/ptfv92jnbogpfvld8eharmsch84m" alt="Massage training" class="rounded-lg shadow-md max-h-96 object-cover">
                            </div>
                            <div class="md:w-1/2 md:pl-12" data-aos="fade-left">
                                <h2 class="text-3xl font-bold mb-4">Why Choose Soma Massage School?</h2>
                                <ul class="space-y-4">
                                    <li class="flex items-center">
                                        <i class="fas fa-check-circle text-indigo-600 mr-2"></i>
                                        <span>Expert instructors with years of experience</span>
                                    </li>
                                    <li class="flex items-center">
                                        <i class="fas fa-check-circle text-indigo-600 mr-2"></i>
                                        <span>State-of-the-art facilities and equipment</span>
                                    </li>
                                    <li class="flex items-center">
                                        <i class="fas fa-check-circle text-indigo-600 mr-2"></i>
                                        <span>Comprehensive curriculum covering various modalities</span>
                                    </li>
                                    <li class="flex items-center">
                                        <i class="fas fa-check-circle text-indigo-600 mr-2"></i>
                                        <span>Flexible class schedules to fit your lifestyle</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </section>
        
                <section class="py-20 bg-gray-100">
                    <div class="container mx-auto px-6">
                        <h2 class="text-3xl font-bold text-center mb-8" data-aos="fade-up">Our Location</h2>
                        <div class="flex flex-col md:flex-row items-center">
                            <div class="md:w-1/2 mb-8 md:mb-0" data-aos="fade-right">
                                <h3 class="text-2xl font-semibold mb-4">Serving Centerville and Bountiful, Utah</h3>
                                <p class="text-gray-600 mb-4">Soma Massage School is proudly located in the heart of Centerville, Utah, just minutes away from beautiful Bountiful. Our prime location allows us to serve students from both communities and the surrounding areas.</p>
                                <p class="text-gray-600 mb-4">Centerville and Bountiful offer a perfect blend of small-town charm and modern amenities, providing an ideal environment for learning and growth. With stunning views of the Wasatch Mountains and easy access to outdoor recreation, our students can find inspiration and relaxation beyond the classroom.</p>
                            </div>
                            <div class="md:w-1/2 md:pl-12" data-aos="fade-left">
                                <img src="https://picsum.photos/800/600" alt="Centerville, Utah" class="rounded-lg shadow-md">
                            </div>
                        </div>
                    </div>
                </section>
        
                <section class="py-20">
                    <div class="container mx-auto px-6">
                        <h2 class="text-3xl font-bold text-center mb-8" data-aos="fade-up">Meet Our Founder: Kim Kendall</h2>
                        <div class="flex flex-col md:flex-row items-center">
                            <div class="md:w-1/3 mb-8 md:mb-0" data-aos="fade-right">
                                <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/dwhvk6dflfdxgl3loja6tb676fcc" alt="Kim Kendall" class="rounded-full shadow-md mx-auto">
                            </div>
                            <div class="md:w-2/3 md:pl-12" data-aos="fade-left">
                                <h3 class="text-2xl font-semibold mb-4">Kim Kendall: Experienced Educator and Practitioner</h3>
                                <p class="text-gray-600 mb-4">Kim Kendall brings a wealth of experience to Soma Massage School. With over 15 years in the massage therapy industry, Kim has dedicated her career to both practicing and teaching the art of healing touch.</p>
                                <p class="text-gray-600 mb-4">Before founding Soma Massage School, Kim honed her teaching skills at the prestigious Renaissance Massage School. There, she developed a reputation for her engaging teaching style and ability to break down complex techniques into easily understandable components.</p>
                                <p class="text-gray-600 mb-4">In addition to her teaching experience, Kim has worked extensively as a massage therapist at Hand and Stone in Bountiful, UT. This hands-on experience in a professional setting allows her to bring real-world insights to her students, preparing them for successful careers in massage therapy.</p>
                            </div>
                        </div>
                    </div>
                </section>
        
                <section class="bg-indigo-100 py-20">
                    <div class="container mx-auto px-6">
                        <h2 class="text-3xl font-bold text-center mb-8" data-aos="fade-up">Kim's Approach to Massage Education</h2>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                            <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up">
                                <h3 class="text-xl font-semibold mb-2">Holistic Learning</h3>
                                <p class="text-gray-600">Kim believes in teaching massage therapy as a holistic practice, emphasizing the connection between body, mind, and spirit.</p>
                            </div>
                            <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up" data-aos-delay="200">
                                <h3 class="text-xl font-semibold mb-2">Practical Experience</h3>
                                <p class="text-gray-600">Drawing from her work at Hand and Stone, Kim ensures students gain practical, industry-relevant skills.</p>
                            </div>
                            <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up" data-aos-delay="400">
                                <h3 class="text-xl font-semibold mb-2">Personalized Attention</h3>
                                <p class="text-gray-600">Kim's teaching style focuses on individual growth, providing personalized feedback and support to each student.</p>
                            </div>
                            <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up" data-aos-delay="600">
                                <h3 class="text-xl font-semibold mb-2">Continuous Learning</h3>
                                <p class="text-gray-600">Kim encourages students to view massage therapy as a lifelong learning journey, always seeking to improve and grow.</p>
                            </div>
                        </div>
                    </div>
                </section>
        
                <section class="py-20 bg-gray-100">
                    <div class="container mx-auto px-6">
                        <h2 class="text-3xl font-bold text-center mb-8" data-aos="fade-up">Our School Gallery</h2>
                        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
                            <div class="overflow-hidden rounded-lg shadow-md" data-aos="fade-up">
                                <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/dmh98utu5ur2h9r0iz51zxv3auv7" alt="Massage School Image 1" class="w-full h-64 object-cover transition duration-300 ease-in-out transform hover:scale-110">
                            </div>
                            <div class="overflow-hidden rounded-lg shadow-md" data-aos="fade-up" data-aos-delay="100">
                                <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/4l5ebd63nbe6tooq1xjsvo6b6r5i" alt="Massage School Image 2" class="w-full h-64 object-cover transition duration-300 ease-in-out transform hover:scale-110">
                            </div>
                            <div class="overflow-hidden rounded-lg shadow-md" data-aos="fade-up" data-aos-delay="200">
                                <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/t0djj7kafnvuj6ycv7k9d6vw1azg" alt="Massage School Image 3" class="w-full h-64 object-cover transition duration-300 ease-in-out transform hover:scale-110">
                            </div>
                            <div class="overflow-hidden rounded-lg shadow-md" data-aos="fade-up" data-aos-delay="300">
                                <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/fn74osxs5k6ajl5umnwwgrxzh4rq" alt="Massage School Image 4" class="w-full h-64 object-cover transition duration-300 ease-in-out transform hover:scale-110">
                            </div>
                            <div class="overflow-hidden rounded-lg shadow-md" data-aos="fade-up" data-aos-delay="400">
                                <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/j7m60gyahdfesgh0aj7h6fzmay75" alt="Massage School Image 5" class="w-full h-64 object-cover transition duration-300 ease-in-out transform hover:scale-110">
                            </div>
                            <div class="overflow-hidden rounded-lg shadow-md" data-aos="fade-up" data-aos-delay="500">
                                <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/1x278wzhcpaaenqf9nkliapwyi9z" alt="Massage School Image 6" class="w-full h-64 object-cover transition duration-300 ease-in-out transform hover:scale-110">
                            </div>
                            <div class="overflow-hidden rounded-lg shadow-md" data-aos="fade-up" data-aos-delay="600">
                                <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/ki5y1gpkiain4xt6hhfknb6h898g" alt="Massage School Image 7" class="w-full h-64 object-cover transition duration-300 ease-in-out transform hover:scale-110">
                            </div>
                            <div class="overflow-hidden rounded-lg shadow-md" data-aos="fade-up" data-aos-delay="700">
                                <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/atnvojbw5ueg6nelzx27b7t9wzp7" alt="Massage School Image 8" class="w-full h-64 object-cover transition duration-300 ease-in-out transform hover:scale-110">
                            </div>
                        </div>
                    </div>
                </section>
        
                <section class="py-20">
                    <div class="container mx-auto px-6 text-center">
                        <h2 class="text-3xl font-bold mb-8" data-aos="fade-up">What Our Students Say</h2>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                            <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up">
                                <img src="https://picsum.photos/100" alt="Student 1" class="rounded-full w-24 h-24 mx-auto mb-4">
                                <p class="text-gray-600 mb-4">"Soma Massage School changed my life. The instructors are amazing, and I feel confident in my skills."</p>
                                <p class="font-semibold">- Jane Doe</p>
                            </div>
                            <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up" data-aos-delay="200">
                                <img src="https://picsum.photos/101" alt="Student 2" class="rounded-full w-24 h-24 mx-auto mb-4">
                                <p class="text-gray-600 mb-4">"I couldn't be happier with my education at Soma. The hands-on experience was invaluable."</p>
                                <p class="font-semibold">- John Smith</p>
                            </div>
                            <div class="bg-white rounded-lg shadow-md p-6" data-aos="fade-up" data-aos-delay="400">
                                <img src="https://picsum.photos/102" alt="Student 3" class="rounded-full w-24 h-24 mx-auto mb-4">
                                <p class="text-gray-600 mb-4">"The supportive community at Soma made learning enjoyable and helped me grow as a therapist."</p>
                                <p class="font-semibold">- Emily Johnson</p>
                            </div>
                        </div>
                    </div>
                </section>
        
                <section class="bg-indigo-600 text-white py-20">
                    <div class="container mx-auto px-6 text-center">
                        <h2 class="text-3xl font-bold mb-8" data-aos="fade-up">Ready to Start Your Journey?</h2>
                        <p class="text-xl mb-8" data-aos="fade-up" data-aos-delay="200">Enroll now and take the first step towards a rewarding career in massage therapy.</p>
                        <a href="#" class="bg-white text-indigo-600 py-2 px-6 rounded-full text-lg font-semibold hover:bg-indigo-100 transition duration-300" data-aos="fade-up" data-aos-delay="400">Apply Today</a>
                    </div>
                </section>
            </main>
        
            <footer class="bg-gray-800 text-white py-8">
                <div class="container mx-auto px-6">
                    <div class="flex flex-col md:flex-row justify-between items-center">
                        <div class="mb-4 md:mb-0">
                            <h3 class="text-2xl font-bold">Soma Massage School</h3>
                            <p class="text-gray-400">Empowering healers since 2005</p>
                        </div>
                        <div class="flex space-x-4">
                            <a href="#" class="text-gray-400 hover:text-white"><i class="fab fa-facebook-f"></i></a>
                            <a href="#" class="text-gray-400 hover:text-white"><i class="fab fa-instagram"></i></a>
                            <a href="#" class="text-gray-400 hover:text-white"><i class="fab fa-twitter"></i></a>
                            <a href="#" class="text-gray-400 hover:text-white"><i class="fab fa-linkedin-in"></i></a>
                        </div>
                    </div>
                    <hr class="border-gray-700 my-8">
                    <div class="text-center text-gray-400">
                        <p>&copy; 2023 Soma Massage School. All rights reserved.</p>
                    </div>
                </div>
            </footer>
        
            <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
            <script>
                AOS.init({
                    duration: 1000,
                    once: true,
                });
            </script>
        </body>
        </html>
          HTML
    end
end
