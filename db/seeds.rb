# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Create Organization
organization = Organization.create!(
  name: "Lama Press",
  city: "San Francisco",
  phone: "415-555-1212",
  notes: "This is a test organization",
  state: "CA",
  street_address: "123 Main St",
  zip_code: "94105",
  email: "kody@somaschoolofmassage.com"
)

# Create User
user = User.create!(
  phone: 1234567890,
  first_name: "Kody",
  last_name: "Kendall",
  organization: organization,
  email: "kody@llamapress.ai",
  password: "123456",
  api_token: "quickstart_api_token"
)

# Create Site
site = Site.create!(
  organization: organization,
  name: "Soma School of Massage",
  slug: "/soma"
)

# Create Page
page = Page.create!(
  site: site,
  slug: "soma-school-of-massage",
  organization: organization,
  content: <<~HTML,
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
)

# Create Site
site = Site.create!(
    organization: organization,
    name: "Signature Roofing",
    slug: "/signature-roofing"
  )

# Create Page
page = Page.create!(
  site: site,
  slug: "signature-roofing",
  organization: organization,
  content: <<~HTML,
    <!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Roofing Advocate - Signature Roofing</title>
    <link rel="icon" href="https://service-jobs-images.s3.us-east-2.amazonaws.com/wj5fk47d8y19y47rhv2x4ht9r24i" type="image/x-icon">
    <link
        href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700&family=Open+Sans:wght@400;500;600;700&display=swap"
        rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css">
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Open Sans', sans-serif;
        }

        .container {
            max-width: 1230px;
            padding-left: 15px;
            padding-right: 15px;
            margin-left: auto;
            margin-right: auto;
        }

        .bgNavyBlue {
            background-color: #001f3f;
        }

        .bgHoverNavyBlue:hover {
            background-color: #001f3f;
        }

        .textNavyBlue {
            color: #001f3f;
        }

        .textPrimary {
            color: #F7C244;
        }

        .textTitle {
            color: #001f3f;
        }

        .hoverColorNavyBlue:hover {
            color: #001f3f;
        }

        .hoverBg:hover {
            background-color: #F7C244 !important;
        }

        .hoverColor:hover {
            color: #F7C244 !important;
        }

        .bgPrimary {
            background-color: #F7C244;
        }

        h1,
        h2,
        h3,
        h4 {
            font-family: 'Manrope';
        }
    </style>

</head>

<body>
    <!-- Header Section -->
    <header class="absolute top-0 left-0 w-full z-10">
        <div class="border-b border-solid" style="border-color: #ffffff24;">
            <div class="container mx-auto lg:flex justify-between items-center py-4">
                <div class="lg:w-6/12 text-center">
                    <a href="tel:+18014201911" class="text-white text-2xl font-semibold">Call (801) 420-1911</a>
                </div>
                <div class="lg:flex justify-between hidden">
                    <nav>
                        <ul class="flex space-x-8 text-white font-semibold">
                            <li><a href="https://signatureroofing.rocketr.us/wp/signature-roofing-roof-repair" class="text-sm">Our Work</a></li>
                            <li><a href="#" class="text-sm">About</a></li>
                            <li><a href="#" class="text-sm">Frequently Asked Questions</a></li>
                        </ul>
                    </nav>
                    <div class="ml-10">
                        <a href="https://app.fieldrocket.us/l/4279" class="text-black font-semibold py-2 px-4 rounded hover:bg-yellow-600"
                            style="background-color: #F7C244;">
                            Free Consultation
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="container mx-auto flex justify-between items-center py-3">
            <!-- Logo -->
            <div class="logo relative">
                <div class="absolute inset-0 bg-black opacity-10"></div>
                <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/wj5fk47d8y19y47rhv2x4ht9r24i" alt="Logo" class="h-24 relative z-10">
            </div>

            <!-- Menu Items -->
            <nav>
                <ul class="hidden lg:flex space-x-8 text-white uppercase font-semibold">
                    <li><a href="#" class="text-base">Insurance Claims</a></li>
                    <li><a href="#" class="text-base">Roofing Services</a></li>
                    <li><a href="#" class="text-base">Contact</a></li>
                </ul>
            </nav>
        </div>
    </header>
    <!-- End Header Section -->

    <!-- Hero Section -->
    <section class="relative">
        <div class="absolute h-full w-full bg-no-repeat bg-cover bg-center"
            style="background-image: url(https://service-jobs-images.s3.us-east-2.amazonaws.com/85achbg26s0q0fgks5xp5f7i291y);"></div>
        <div class="absolute h-full w-full left-0 top-0x" style="background-color: #001f3f69;"></div>
        <div class="container mx-auto">
            <div class="relative z-10 lg:w-10/12 xl:w-8/12 mx-auto text-center pt-60 md:pt-72 pb-32 md:pb-48">
                <h2 class="text-white text-5xl xl:text-6xl font-bold mb-8 leading-tight">
                    Signature Roofing: <br> Your Roofing Advocate
                </h2>
                <p class="text-white text-lg font-medium mb-8">
                    Is Your Roof Damaged? We've Got You Covered! Don't let a damaged roof leave you exposed.
                </p>
                <div class="md:flex items-center justify-center gap-10 text-center">
                    <a href="#"
                        class="block text-xl text-white font-semibold py-4 duration-200 transition-all hoverColor mb-6 md:mb-0">
                        Our Services
                        <i class="fas fa-angle-right hoverColor ml-2"></i>
                    </a>
                    <div>
                        <a href="https://app.fieldrocket.us/l/4279"
                            class="bgPrimary text-xl text-black font-semibold py-3 px-10 rounded-sm hover:bg-white hoverColorNavyBlue duration-200 transition-all">
                            Get Free Consultation
                        </a>
                    </div>

                </div>
            </div>
        </div>
    </section>
    <!-- End Hero Section -->

    <!-- Beautiful Exteriors -->
    <section class="py-20 relative">
        <div class="flex gap-10 mb-10 relative">
            <div class="w-4/12 flex flex-col justify-end md:justify-between h-full absolute" style="padding-left: 5%;">
                <div class="w-10 hidden md:grid grid-cols-2 gap-1 bg-white p-1 rounded-sm">
                    <span class="h-3 w-3 bgNavyBlue block" style="border-radius: 50%;"></span>
                    <span class="h-3 w-3 bgNavyBlue bg-opacity-60 block"
                        style="border-radius: 50%; background-color: #99ccff;"></span>
                    <span class="h-3 w-3 bgNavyBlue bg-opacity-50 block"
                        style="border-radius: 50%; background-color: #99ccff;"></span>
                    <span class="h-3 w-3 bgNavyBlue block"
                        style="border-radius: 50%; background-color: #99ccff;"></span>
                </div>
                <div><img class="h-32" src="./img/moderne-architektur-arrow.webp" alt=""></div>
            </div>
            <div class="ml-auto pl-20 md:pl-48 lg:pl-96">
                <div class="relative">
                    <div class="absolute left-4 top-4 z-20 md:hidden grid grid-cols-2 gap-1 bg-white p-1 rounded-sm">
                        <span class="h-3 w-3 bgNavyBlue block" style="border-radius: 50%;"></span>
                        <span class="h-3 w-3 bgNavyBlue bg-opacity-60 block"
                            style="border-radius: 50%; background-color: #99ccff;"></span>
                        <span class="h-3 w-3 bgNavyBlue bg-opacity-50 block"
                            style="border-radius: 50%; background-color: #99ccff;"></span>
                        <span class="h-3 w-3 bgNavyBlue block"
                            style="border-radius: 50%; background-color: #99ccff;"></span>
                    </div>
                    <img class="w-auto" src="https://service-jobs-images.s3.us-east-2.amazonaws.com/70hjsifytcs9lg3bzq9mimxv8pi0" alt="">
                </div>
            </div>
        </div>
        <div class="mx-auto">
            <div class="md:flex  gap-10">
                <p class="text-lg font-medium md:w-4/12 px-4 md:pl-20 mb-8 md:mb-0" style="color: rgba(0, 0, 0, 0.67);">
                    At <a href="#" style="color: rgb(247, 194, 68);">Signature Roofing</a>, we're more than just roofers – 
                    we're your advocates in the complex world of insurance claims and top-quality repairs.
                </p>
                <div class="md:w-6/12 mx-5">
                    <h2 class="textTitle text-4xl md:text-5xl font-bold mb-4">Stunning Roofing Solutions</h2>
                    <p class="text-xl font-medium leading-normal" style="color: #1d1d1f;">
                        From Shingles to Siding: Your Go-To Experts for Transforming Utah's Home Exteriors.
                    </p>
                </div>
            </div>
        </div>
    </section>
    <!-- End Roofing Solutions -->


    <section class="px-8 pt-10 md:pt-20 pb-20 md:pb-32 max-w-7xl mx-auto">
        <h2 class="text-xl font-medium leading-normal" style="color: #1d1d1f;">We solve every roofing challenge:</h2>
        <h1 class="text-4xl md:text-5xl font-bold mb-4 textTitle">
            Utah's premier <span class="text-yellow-400">roofing</span> services
        </h1>
    
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mt-10">
            <!-- Roof Installations -->
            <div class="mb-6">
                <div class="text-yellow-400 mb-2">
                    <!-- Icon for Roof Installations -->
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 512" width="36" height="36" fill="#F7C244">
                        <path d="M335.5 4l288 160c15.4 8.6 21 28.1 12.4 43.5s-28.1 21-43.5 12.4L320 68.6 47.5 220c-15.4 8.6-34.9 3-43.5-12.4s-3-34.9 12.4-43.5L304.5 4c9.7-5.4 21.4-5.4 31.1 0zM320 160a40 40 0 1 1 0 80 40 40 0 1 1 0-80zM144 256a40 40 0 1 1 0 80 40 40 0 1 1 0-80zm312 40a40 40 0 1 1 80 0 40 40 0 1 1 -80 0zM226.9 491.4L200 441.5V480c0 17.7-14.3 32-32 32H120c-17.7 0-32-14.3-32-32V441.5L61.1 491.4c-6.3 11.7-20.8 16-32.5 9.8s-16-20.8-9.8-32.5l37.9-70.3c15.3-28.5 45.1-46.3 77.5-46.3h19.5c16.3 0 31.9 4.5 45.4 12.6l33.6-62.3c15.3-28.5 45.1-46.3 77.5-46.3h19.5c32.4 0 62.1 17.8 77.5 46.3l33.6 62.3c13.5-8.1 29.1-12.6 45.4-12.6h19.5c32.4 0 62.1 17.8 77.5 46.3l37.9 70.3c6.3 11.7 1.9 26.2-9.8 32.5s-26.2 1.9-32.5-9.8L552 441.5V480c0 17.7-14.3 32-32 32H472c-17.7 0-32-14.3-32-32V441.5l-26.9 49.9c-6.3 11.7-20.8 16-32.5 9.8s-16-20.8-9.8-32.5l36.3-67.5c-1.7-1.7-3.2-3.6-4.3-5.8L376 345.5V400c0 17.7-14.3 32-32 32H296c-17.7 0-32-14.3-32-32V345.5l-26.9 49.9c-1.2 2.2-2.6 4.1-4.3 5.8l36.3 67.5c6.3 11.7 1.9 26.2-9.8 32.5s-26.2 1.9-32.5-9.8z">
                        </path>
                    </svg>
                </div>
                <h3 class="text-xl font-semibold textTitle mb-3">Roof Installations</h3>
                <p class="text-base font-medium text-black text-opacity-70">
                    Elevate your home's protection and curb appeal with our expert roof installations. Choose from a variety of styles and materials to fit your budget and aesthetic.
                </p>
            </div>
            <!-- Roof Repairs -->
            <div class="mb-6">
                <div class="text-yellow-400 mb-2">
                    <!-- Icon for Roof Repairs -->
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 512" width="36" height="36" fill="#F7C244">
                        <path d="M0 488V171.3c0-26.2 15.9-49.7 40.2-59.4L308.1 4.8c7.6-3.1 16.1-3.1 23.8 0L599.8 111.9c24.3 9.7 40.2 33.3 40.2 59.4V488c0 13.3-10.7 24-24 24H568c-13.3 0-24-10.7-24-24V224c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32V488c0 13.3-10.7 24-24 24H24c-13.3 0-24-10.7-24-24zM376 384H488c13.3 0 24 10.7 24 24v80c0 13.3-10.7 24-24 24H376c-13.3 0-24-10.7-24-24V408c0-13.3 10.7-24 24-24zM128 248c0-13.3 10.7-24 24-24H296c13.3 0 24 10.7 24 24v80c0 13.3-10.7 24-24 24H152c-13.3 0-24-10.7-24-24V248zm24 136H296c13.3 0 24 10.7 24 24v80c0 13.3-10.7 24-24 24H152c-13.3 0-24-10.7-24-24V408c0-13.3 10.7-24 24-24z">
                        </path>
                    </svg>
                </div>
                <h3 class="text-xl font-semibold textTitle mb-3">Roof Repairs</h3>
                <p class="text-base font-medium text-black text-opacity-70">
                    From minor leaks to major damage, our skilled team is ready to restore your roof to its best condition, keeping your home safe from the elements.
                </p>
            </div>
            <!-- Roof Replacements -->
            <div class="mb-6">
                <div class="text-yellow-400 mb-2">
                    <!-- Icon for Roof Replacements -->
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="36" height="36" fill="#F7C244">
                        <path d="M224 480H448c17.7 0 32-14.3 32-32V224c0-17.7-14.3-32-32-32H384V160h64c35.3 0 64 28.7 64 64V448c0 35.3-28.7 64-64 64H224c-35.3 0-64-28.7-64-64V384h32v64c0 17.7 14.3 32 32 32zM64 320H288c17.7 0 32-14.3 32-32V64c0-17.7-14.3-32-32-32H64C46.3 32 32 46.3 32 64V288c0 17.7 14.3 32 32 32zm224 32H64c-35.3 0-64-28.7-64-64V64C0 28.7 28.7 0 64 0H288c35.3 0 64 28.7 64 64V288c0 35.3-28.7 64-64 64zm-32-96V96H96V256H256zm32 0c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V96c0-17.7 14.3-32 32-32H256c17.7 0 32 14.3 32 32V256z">
                        </path>
                    </svg>
                </div>
                <h3 class="text-xl font-semibold textTitle mb-3">Roof Replacements</h3>
                <p class="text-base font-medium text-black text-opacity-70">
                    Is your roof showing signs of wear? Our replacement services provide a fresh start, using long-lasting materials to enhance both beauty and functionality.
                </p>
            </div>
            <!-- Weatherproofing -->
            <div class="mb-6">
                <div class="text-yellow-400 mb-2">
                    <!-- Icon for Weatherproofing -->
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="36" height="36" fill="#F7C244">
                        <path d="M0 488V171.3c0-26.2 15.9-49.7 40.2-59.4L308.1 4.8c7.6-3.1 16.1-3.1 23.8 0L599.8 111.9c24.3 9.7 40.2 33.3 40.2 59.4V488c0 13.3-10.7 24-24 24H568c-13.3 0-24-10.7-24-24V224c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32V488c0 13.3-10.7 24-24 24H24c-13.3 0-24-10.7-24-24zM376 384H488c13.3 0 24 10.7 24 24v80c0 13.3-10.7 24-24 24H376c-13.3 0-24-10.7-24-24V408c0-13.3 10.7-24 24-24zM128 248c0-13.3 10.7-24 24-24H296c13.3 0 24 10.7 24 24v80c0 13.3-10.7 24-24 24H152c-13.3 0-24-10.7-24-24V248zm24 136H296c13.3 0 24 10.7 24 24v80c0 13.3-10.7 24-24 24H152c-13.3 0-24-10.7-24-24V408c0-13.3 10.7-24 24-24z">
                        </path>
                    </svg>
                </div>
                <h3 class="text-xl font-semibold textTitle mb-3">Weatherproofing</h3>
                <p class="text-base font-medium text-black text-opacity-70">
                    Safeguard your home from Utah’s harsh weather conditions with our specialized weatherproofing solutions, designed to keep your roof strong all year round.
                </p>
            </div>
        </div>
    </section>
    
    <!-- Expertise Section -->
    <section class="bg-cover bg-center bg-repeat"
        style="background-image: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url(brick-wall.png), radial-gradient(at center top, #777777, #000000);">
        <div class="pb-10 md:pb-20 bg-center bg-repeat" style="background-image: url(./img/brick-wall-dark.webp);">
            <div class="container">
                <div class="flex flex-col lg:flex-row items-center">
                    <!-- Left Text Section -->
                    <div class="lg:w-1/2 px-4 mb-6">
                        <h2 class="text-4xl md:text-5xl font-bold mb-4 text-white pt-20">Utah Expertise</h2>
                        <p class="text-white text-xl font-medium leading-normal">
                            Unmatched Craftsmanship: Why Signature Roofing is Your Go-To for Exterior Transformations.
                        </p>
                    </div>
                    <!-- Right Image Section -->
                    <div class="lg:w-1/2 px-4 lg:-mt-20">
                        <div class="pl-20">
                            <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/tbyl2qnqyvb2u8kvxfbpdthiw4ka" alt="Utah Home"
                                class="rounded-lg shadow-lg w-full h-auto">
                        </div>
                    </div>
                </div>

                <!-- Cards Section -->
                <div class="mt-12 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 px-4">
                    <div class="bg-white text-gray-900 p-6 rounded-lg shadow-lg">
                        <h3 class="text-xl font-semibold mb-2">Insurance Claim Experts</h3>
                        <p class="text-base font-medium text-black text-opacity-70 mb-4">
                            We navigate the complexities of insurance claims, ensuring you get the coverage you deserve.
                        </p>
                        <div class="text-right">
                            <a href="#" class="textPrimary text-2xl ml-auto">
                                <i class="fas fa-arrow-right ml-2"></i>
                            </a>
                        </div>
                    </div>

                    <div class="bg-white text-gray-900 p-6 rounded-lg shadow-lg">
                        <h3 class="text-xl font-semibold mb-2">Contractor-Led Expertise</h3>
                        <p class="mb-4">
                            Led by actual roofing contractors, not salespeople. 
                            Our founder, AJ Gonzalez, is a 2nd generation roofer with 15+ years of hands-on experience.
                        </p>
                        <div class="text-right">
                            <a href="#" class="textPrimary text-2xl ml-auto">
                                <i class="fas fa-arrow-right ml-2"></i>
                            </a>
                        </div>
                    </div>

                    <div class="bg-white text-gray-900 p-6 rounded-lg shadow-lg">
                        <h3 class="text-xl font-semibold mb-2">In-House Roofing Talent</h3>
                        <p class="mb-4">
                            45+ years of combined roofing experience. 
                            Our management and installation teams are all expert roofers, ensuring top-quality work and superior customer support.
                        </p>
                        <div class="text-right">
                            <a href="#" class="textPrimary text-2xl ml-auto">
                                <i class="fas fa-arrow-right ml-2"></i>
                            </a>
                        </div>
                    </div>

                    <div class="bg-white text-gray-900 p-6 rounded-lg shadow-lg">
                        <h3 class="text-xl font-semibold mb-2">Exceptional Value</h3>
                        <p class="mb-4">
                            Get up to $1500 off your project in cash or material upgrades!
                        </p>
                        <div class="text-right">
                            <a href="#" class="textPrimary text-2xl ml-auto">
                                <i class="fas fa-arrow-right ml-2"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- End Expertise Section -->

    <!-- Showcase -->
    <section class="py-20">
        <div class="mx-auto">
            <div class="lg:w-6/12 w-10/12 mx-auto text-center mb-16">
                <h2 class="textTitle text-4xl md:text-5xl font-bold mb-8">Showcase</h1>
                    <p class="text-xl font-medium leading-normal mb-8" style="color: #1d1d1f;">
                        Below, you'll discover a collection of examples showcasing how our expert roofing team 
                        and innovative design strategies have transformed home exteriors, 
                        elevating both their visual appeal and practical functionality.
                    </p>

                    <div class="flex items-center justify-center gap-4">
                        <a href="#"
                            class="block text-xl text-black font-semibold py-4 duration-200 transition-all hoverColor mb-6 md:mb-0">
                            Rendering services
                            <i class="fas fa-arrow-right hoverColor ml-2"></i>
                        </a>
                        <div class="ml-8">
                            <a href="#"
                                class="inline-block bgPrimary text-xl text-black font-semibold py-2 px-8 rounded-md bgHoverNavyBlue duration-200 transition-all">
                                Get Started
                            </a>
                        </div>
                    </div>
            </div>

            <div class="owl-carousel owl-theme">
                <div class="item">
                    <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/5tv98choeibhmnvpb1xpq59i5pv4" alt="Image 1" class="w-full h-auto">
                </div>
                <div class="item">
                    <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/jlo17v2gpi5fqgbl4ep86oxw62qg" alt="Image 2" class="w-full h-auto">
                </div>
                <div class="item">
                    <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/36v2vz7y2z09horoep9atcroht9z" alt="Image 3" class="w-full h-auto">
                </div>
                <div class="item">
                    <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/dma9iy59g20we5pjicb1iyzycw1a" alt="Image 4" class="w-full h-auto">
                </div>
            </div>
        </div>
    </section>
    <!-- End Showcase -->

    <!-- Frequently -->
    <section class="bg-cover bg-center bg-repeat"
        style="background-image: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url(brick-wall.png), radial-gradient(at center top, #777777, #000000);">
        <div class="py-20 bg-center bg-repeat" style="background-image: url(./img/brick-wall-dark.webp);">
            <div class="container">
                <h2 class="text-white text-3xl font-bold mb-8">Frequently Asked Questions</h2>
                <div class="grid md:grid-cols-2 gap-x-8 gap-y-2 mb-10">
                    <div class="border border-gray-700 rounded-lg flex flex-col">
                        <button
                            class="text-xl text-white w-full text-left p-4 flex justify-between items-center focus:outline-none hoverBg hover:text-black hover:text-opacity-70"
                            onclick="toggleAccordion(1)" style="background-color: rgba(0, 0, 0, 0.18);">
                            <span>What services do you offer?</span>
                            <span class="text-2xl">
                                <i class="fas fa-plus"></i>
                            </span>
                        </button>
                        <div id="accordion1" class="overflow-hidden max-h-0 transition-all duration-500">
                            <p class="p-4 text-white">
                                We specialize in a wide range of roofing services, including new roof installations, 
                                roof repairs, roof replacements, and maintenance. We also offer services like gutter installation, 
                                siding, and other exterior improvements to enhance the durability and appearance of your home.
                            </p>
                        </div>
                    </div>
                    <div class="border border-gray-700 rounded-lg flex flex-col">
                        <button
                            class="text-xl text-white w-full text-left p-4 flex justify-between items-center focus:outline-none hoverBg hover:text-black hover:text-opacity-70"
                            onclick="toggleAccordion(2)" style="background-color: rgba(0, 0, 0, 0.18);">
                            <span>What types of roofing materials do you work with?</span>
                            <span class="text-2xl">
                                <i class="fas fa-plus"></i>
                            </span>
                        </button>
                        <div id="accordion2" class="overflow-hidden max-h-0 transition-all duration-500">
                            <p class="p-4 text-white">
                                We work with a variety of roofing materials, including asphalt shingles, metal roofing, 
                                tile, and flat roofing systems. Our team will help you choose the best material based on your budget, 
                                style preferences, and the specific needs of your home.
                            </p>
                        </div>
                    </div>
                    <div class="border border-gray-700 rounded-lg">
                        <button
                            class="text-xl text-white w-full text-left p-4 flex justify-between items-center focus:outline-none hoverBg hover:text-black hover:text-opacity-70"
                            onclick="toggleAccordion(3)" style="background-color: rgba(0, 0, 0, 0.18);">
                            <span>How long does a roof replacement take?</span>
                            <span class="text-2xl">
                                <i class="fas fa-plus"></i>
                            </span>
                        </button>
                        <div id="accordion3" class="overflow-hidden max-h-0 transition-all duration-500">
                            <p class="p-4 text-white">
                                The timeline for a roof replacement depends on factors such as the size of your roof, 
                                the type of materials used, and the weather conditions. Generally, most roof replacements can be completed 
                                within a few days to a week.
                            </p>
                        </div>
                    </div>
                    <div class="border border-gray-700 rounded-lg">
                        <button
                            class="text-xl text-white w-full text-left p-4 flex justify-between items-center focus:outline-none hoverBg hover:text-black hover:text-opacity-70"
                            onclick="toggleAccordion(4)" style="background-color: rgba(0, 0, 0, 0.18);">
                            <span>Do you offer warranties on your roofing services?</span>
                            <span class="text-2xl">
                                <i class="fas fa-plus"></i>
                            </span>
                        </button>
                        <div id="accordion4" class="overflow-hidden max-h-0 transition-all duration-500">
                            <p class="p-4 text-white">
                                Yes, we offer comprehensive warranties on both materials and workmanship. The length and coverage of the 
                                warranty will vary depending on the materials used and the specific service provided. 
                                We will discuss all warranty details with you before the project begins.
                            </p>
                        </div>
                    </div>
                    <div class="border border-gray-700 rounded-lg">
                        <button
                            class="text-xl text-white w-full text-left p-4 flex justify-between items-center focus:outline-none hoverBg hover:text-black hover:text-opacity-70"
                            onclick="toggleAccordion(5)" style="background-color: rgba(0, 0, 0, 0.18);">
                            <span>How much does a new roof cost?</span>
                            <span class="text-2xl">
                                <i class="fas fa-plus"></i>
                            </span>
                        </button>
                        <div id="accordion5" class="overflow-hidden max-h-0 transition-all duration-500">
                            <p class="p-4 text-white">
                                The cost of a new roof varies depending on factors like the size of your roof, the materials chosen, 
                                and the complexity of the installation. We provide free, detailed estimates so you can understand the 
                                costs upfront without any surprises.
                            </p>
                        </div>
                    </div>
                    <div class="border border-gray-700 rounded-lg">
                        <button
                            class="text-xl text-white w-full text-left p-4 flex justify-between items-center focus:outline-none hoverBg hover:text-black hover:text-opacity-70"
                            onclick="toggleAccordion(6)" style="background-color: rgba(0, 0, 0, 0.18);">
                            <span>Can you help with insurance claims for roof damage?</span>
                            <span class="text-2xl">
                                <i class="fas fa-plus"></i>
                            </span>
                        </button>
                        <div id="accordion6" class="overflow-hidden max-h-0 transition-all duration-500">
                            <p class="p-4 text-white">
                                Absolutely! We have experience working with insurance companies and can assist you throughout 
                                the claims process. Our team will provide the necessary documentation and help you navigate the 
                                steps to ensure you receive the coverage you're entitled to.
                            </p>
                        </div>
                    </div>
                </div>
                <button
                    class="bgPrimary text-black font-bold py-3 px-8 rounded-md hover:bg-white duration-200 transition-all">
                    More Inquiries
                </button>
            </div>
        </div>
    </section>
    <!-- End Frequently Section -->

    <!-- Old to Bold Secton -->
    <section class="pt-10 md:pt-20">
        <div class="container">
            <div class="text-center md:w-6/12 mx-auto mb-10">
                <h1 class="textTitle text-4xl md:text-5xl font-bold mb-8 leading-tight">Transforming the Ordinary</h1>
                <p class="text-xl font-medium leading-normal mb-8" style="color: #1d1d1f;">
                    Experience how our expert roofing services breathe new life into outdated exteriors, creating bold, modern designs that stand out.
                </p>
            </div>
            <div class="relative">
                <div>
                    <img class="w-full" src="https://service-jobs-images.s3.us-east-2.amazonaws.com/79wzr9vut3a9mgfdrbcitg54jovk" alt="After"
                        class="absolute inset-0 w-full h-auto pointer-events-none">
                </div>
            </div>
        </div>
    </section>
    <!-- End Old to Bold Secton -->

    <!-- Customer Review Section -->
    <section class="py-20">
        <div class="mx-auto">
            <div class="lg:w-6/12 w-10/12 mx-auto text-center mb-16">
                <h2 class="textTitle text-4xl md:text-5xl font-bold mb-8">Our Clients Speak for Us</h1>
                    <p class="text-xl font-medium leading-normal mb-8" style="color: #1d1d1f;">
                        At Signature Roofing, we pride ourselves on delivering exceptional roofing services that exceed
                         our clients' expectations. But don’t just take our word for it—hear directly from the homeowners 
                         we’ve had the pleasure of working with.
                    </p>
            </div>

            <div class="owl-carousel owl-theme">
                <div class="item">
                    <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/kg2shg7c7hoxkjm5fp6qpjrm2xp3" alt="Image 1" class="w-full h-auto">
                </div>
                <div class="item">
                    <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/duywwqfv626ekg68smgzba8qlnfa" alt="Image 2" class="w-full h-auto">
                </div>
                <div class="item">
                    <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/ebgaxupv0ecfljzgqkg8m9uk85v5" alt="Image 3" class="w-full h-auto">
                </div>
                <div class="item">
                    <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/esq8ritltmtrrqp163c4uxrc1bnk" alt="Image 4" class="w-full h-auto">
                </div>
                <div class="item">
                    <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/852fp4qr5x31r3fffagiao1aqf9a" alt="Image 5" class="w-full h-auto">
                </div>
                <div class="item">
                    <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/4x95omx9xcs0tbm4kxngr2gq8ghw" alt="Image 6" class="w-full h-auto">
                </div>
                <div class="item">
                    <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/30mkov0312xavyqd6zw28466cqv5" alt="Image 7" class="w-full h-auto">
                </div>
            </div>
        </div>
    </section>
    <!-- End Customer Review Section -->

    <!-- Customer Jobs -->
    <section class="pt-10 md:pt-20 pb-5">
        <div class="container">
            <!-- Title Section -->
            <div class="text-center mb-12">
                <h2 class="ttextTitle text-4xl md:text-5xl font-bold mb-8 leading-tight">Customer Jobs</h2>
                <p class="text-xl font-medium leading-normal mb-8" style="color: #1d1d1f;">Explore some of our recent
                    jobs.</p>
            </div>
            <!-- Jobs Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <!-- Job Item 1 -->
                <div class="bg-white shadow-md rounded-lg overflow-hidden">
                    <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/sehozhz1lfrpgwv7eqspswww6311"
                        alt="Job 1" class="w-full h-48 object-cover">
                    <div class="p-4">
                        <h3 class="text-lg font-bold text-black text-opacity-90 mb-3">Affordable Utah Roofing & Restoration: Get Free Consult Now!</h3>
                        <p class="text-black text-opacity-50 mb-5">How Signature Roofing Revitalized Leesa's Home with Expert Utah Roofing Services. Roofing and gutter restoration of a Utah...</p>
                        <div class="flex items-center text-gray-700">
                            <i class="fas fa-user text-md"></i>
                            <span class="ml-2 text-black text-base">Chris</span>
                        </div>
                    </div>
                </div>

                <!-- Job Item 2 -->
                <div class="bg-white shadow-md rounded-lg overflow-hidden">
                    <img src="https://fieldrocket-seo-optimized-images.s3.amazonaws.com/Salt-lake-city,-UT-IKO-brand-Dynasty-Shingle--Utah-Roofing--Insurance-Restoration-Roofing-Utah--Wind-Damage-Roofing-3753.jpg"
                        alt="Job 2" class="w-full h-48 object-cover">
                    <div class="p-4">
                        <h3 class="text-lg font-bold text-black text-opacity-90 mb-3">
                            Affordable IKO Dynasty Roofing Solutions in Salt Lake City
                        </h3>
                        <p class="text-black text-opacity-50 mb-5">
                            Summary: Discover how Signature Roofing, led by skilled contractor Chris, 
                            skillfully restored Jill's home in Salt Lake City...
                        </p>
                        <div class="flex items-center text-gray-700">
                            <i class="fas fa-user text-md"></i>
                            <span class="ml-2 text-black text-base">Chris</span>
                        </div>
                    </div>
                </div>

                <!-- Job Item 3 -->
                <div class="bg-white shadow-md rounded-lg overflow-hidden">
                    <img src="https://fieldrocket-seo-optimized-images.s3.amazonaws.com/Sugarhouse-Salt-Lake-City--Sugarhouse-Salt-Lake-City--893.jpg"
                        alt="Job 3" class="w-full h-48 object-cover">
                    <div class="p-4">
                        <h3 class="text-lg font-bold text-black text-opacity-90 mb-3">Signature Roofing Fixes Leaks in Sugarhouse: Affordable & Warrantied</h3>
                        <p class="text-black text-opacity-50 mb-5">The Story of Our Roof Repair in Sugarhouse Salt Lake City
                            Discover how Signature Roofing brought peace of mind...</p>
                        <div class="flex items-center text-gray-700">
                            <i class="fas fa-user text-md"></i>
                            <span class="ml-2 text-black text-base">Chris</span>
                        </div>
                    </div>
                </div>

                <!-- Job Item 4 -->
                <div class="bg-white shadow-md rounded-lg overflow-hidden">
                    <img src="https://fieldrocket-seo-optimized-images.s3.amazonaws.com/South-Salt-Lake,-Utah-IKO-class-3-Dynasty-Shingle--Utah-Roofing--Insurance-Roofing-Renewal-Requirement--ridge-venting-system-by-Lomanco-3904.jpg"
                        alt="Job 3" class="w-full h-48 object-cover">
                    <div class="p-4">
                        <h3 class="text-lg font-bold text-black text-opacity-90 mb-3">Affordable Roof Installations in South Salt Lake | Signature Roofing</h3>
                        <p class="text-black text-opacity-50 mb-5">Transforming Rooftops in South Salt Lake, Utah: A Signature Roofing Story
                            How Signature Roofing Elevated Chris's Home...</p>
                        <div class="flex items-center text-gray-700">
                            <i class="fas fa-user text-md"></i>
                            <span class="ml-2 text-black text-base">Chris</span>
                        </div>
                    </div>
                </div>

                <!-- Job Item 5 -->
                <div class="bg-white shadow-md rounded-lg overflow-hidden">
                    <img src="https://fieldrocket-seo-optimized-images.s3.amazonaws.com/Layton,-UT-IKO-brand---Nordic-Shingles--Utah-Roofing-Installation--HOA-Roof-Replacement-142.jpg"
                        alt="Job 3" class="w-full h-48 object-cover">
                    <div class="p-4">
                        <h3 class="text-lg font-bold text-black text-opacity-90 mb-3">Roofing Installation Experts in Layton, UT | Signature Roofing</h3>
                        <p class="text-black text-opacity-50 mb-5">Transforming Layton One Roof at a Time: Signature Roofing's Mission
                            An in-depth look at how Signature Roofing is changing the...</p>
                        <div class="flex items-center text-gray-700">
                            <i class="fas fa-user text-md"></i>
                            <span class="ml-2 text-black text-base">Chris</span>
                        </div>
                    </div>
                </div>

                <!-- Job Item 6 -->
                <div class="bg-white shadow-md rounded-lg overflow-hidden">
                    <img src="https://fieldrocket-seo-optimized-images.s3.amazonaws.com/Herriman,-UT-IKO-brand-Dynasty-Shingle--Utah-Roofing--Insurance-Restoration-Roofing-Utah--Wind-Damage-Roofing---5957.jpg"
                        alt="Job 3" class="w-full h-48 object-cover">
                    <div class="p-4">
                        <h3 class="text-lg font-bold text-black text-opacity-90 mb-3">Windproof Your Roof: Save Big in Herriman with Signature Roofing</h3>
                        <p class="text-black text-opacity-50 mb-5">Transforming Homes in Herriman, UT with Signature Roofing
                            An in-depth look into...</p>
                        <div class="flex items-center text-gray-700">
                            <i class="fas fa-user text-md"></i>
                            <span class="ml-2 text-black text-base">Chris</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- End Customer Jobs -->

    <!-- Cta Section -->
    <section class="py-10 md:py-20">
        <div class="px-4 md:px-10">
            <img class="w-full h-full" src="https://service-jobs-images.s3.us-east-2.amazonaws.com/aliv4fruxdlyovt6j2lzg9gytsqt" style="max-height: 600px;"
                alt="Contact Image" class="object-cover w-full h-full">
        </div>
        <div class="container">
            <div class="md:w-10/12 mx-auto flex flex-col md:flex-row p-4 md:p-8 rounded-sm bg-white -mt-20 relative ">
                <div class="flex flex-col md:flex-row">
                    <div class="w-full md:w-4/12">
                        <h2 class="text-2xl font-bold mb-4 text-gray-800">Get in touch</h2>
                        <div class="flex items-center gap-3 mb-3">
                            <span class="textNavyBlue">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512" width="24" height="24"
                                    fill="#001f3f">
                                    <path
                                        d="M496 160A80 80 0 1 0 496 0a80 80 0 1 0 0 160zm16 224V190.9c-5.2 .7-10.6 1.1-16 1.1c-22.5 0-43.5-6.6-61-18.1L291.5 291.7c-20.7 17-50.4 17-71.1 0L48 150.1V128c0-8.8 7.2-16 16-16H388.6c-3-10.1-4.6-20.9-4.6-32c0-5.4 .4-10.8 1.1-16H64C28.7 64 0 92.7 0 128V384c0 35.3 28.7 64 64 64H448c35.3 0 64-28.7 64-64zM48 212.2L190 328.8c38.4 31.5 93.7 31.5 132 0L464 212.2V384c0 8.8-7.2 16-16 16H64c-8.8 0-16-7.2-16-16V212.2z">
                                    </path>
                                </svg>
                            </span>
                            <p class="text-gray-600 mb-2">
                                <span class="text-lg font-semibold textNavyBlue block mb-1">Email:</span> <a
                                    href="mailto:chris@signatureroofingut.com"
                                    class="text-base font-normal textNavyBlue block">chris@signatureroofingut.com</a>
                            </p>
                        </div>

                        <div class="text-gray-600 mb-4 flex items-center gap-2">
                            <span class="textNavyBlue">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512" width="24" height="24"
                                    fill="#001f3f">
                                    <path
                                        d="M256 48V64c0 8.8-7.2 16-16 16H144c-8.8 0-16-7.2-16-16V48H96C78.3 48 64 62.3 64 80V432c0 17.7 14.3 32 32 32H288c17.7 0 32-14.3 32-32V80c0-17.7-14.3-32-32-32H256zM16 80C16 35.8 51.8 0 96 0H288c44.2 0 80 35.8 80 80V432c0 44.2-35.8 80-80 80H96c-44.2 0-80-35.8-80-80V80z">
                                    </path>
                                </svg>
                            </span>
                            <p>
                                <span class="text-lg font-semibold textNavyBlue block mb-1">Phone:</span>
                                <a href="tel:+18014201911" class="text-base font-normal textNavyBlue block">(801) 420-1911</a>
                            </p>
                        </div>
                        <div class="flex space-x-4 px-6">
                            <a href="#" class="text-xl">
                                <i class="fab fa-facebook-f textNavyBlue hoverColor"></i>
                            </a>
                            <a href="#" class="text-xl"><i class="fab fa-instagram textNavyBlue hoverColor"></i></a>
                        </div>
                    </div>

                    <div class="w-full md:w-8/12 mt-6 md:mt-0">
                        <div class="md:pl-10">
                            <h2 class="text-2xl font-bold mb-4 text-gray-800">Contact form</h2>
                            <p class="text-gray-600 mb-4">Please fill out the form below and let us know how we
                                can
                                help. We'll respond the same day.</p>
                            <button class="bgNavyBlue text-white px-4 py-2 rounded">Use online form</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- End Cta Section -->

    <!-- Footer Section -->
    <footer class="text-white" style="background-color: #1d1d1d;">
        <div class="container mx-auto py-10 md:py-20">
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
                <!-- Locations -->
                <div>
                    <h3 class="text-xl font-bold mb-6">
                        Locations
                        <span class="block border-b-4 border-solid pb-3 w-10" style="border-color: #3b3b3b;"></span>
                    </h3>

                    <p class="text-xl font-semibold textPrimary mb-3">Location</p>
                    <p class="text-base font-normal mb-4">1641 West 1320 North, Provo, Utah 84604</p>
                    <p class="text-base font-normal mb-8">Serving Northern Utah from Ogden to Utah County.</p>
                    <p class="text-xl font-semibold textPrimary mb-4">Signature Roofing</p>
                    <p class="text-base font-normal mb-6">Bartlett Roofing is a division of Signature Roofing.</p>
                </div>

                <!-- Contact -->
                <div>
                    <h3 class="text-lg font-semibold mb-6">
                        Contact
                        <span class="block border-b-4 border-solid pb-3 w-10" style="border-color: #3b3b3b;"></span>
                    </h3>
                    <p class="mb-8">
                        <span class="text-xl font-semibold textPrimary block mb-3">Call Today</span>
                        <a href="tel:+18014201911" class="text-base font-normal">(801) 420-1911</a>
                    </p>
                    <p>
                        <span class="text-xl font-semibold textPrimary block mb-3">Email Us</span>
                        <a href="mailto:chris@signatureroofingut.com"
                            class="text-base font-normal">chris@signatureroofingut.com</a>
                    </p>
                </div>

                <!-- Menus -->
                <div>
                    <h3 class="text-lg font-semibold mb-4">
                        Menus
                        <span class="block border-b-4 border-solid pb-3 w-10" style="border-color: #3b3b3b;"></span>
                    </h3>

                    <ul class="grid grid-cols-2 gap-4">
                        <li><a href="#" class="text-base font-normal mb-2">Roofing Services</a></li>
                        <li><a href="#" class="text-base font-normal mb-2">Contact</a></li>
                        <li><a href="#" class="text-base font-normal mb-2">Our Work</a></li>
                        <li><a href="#" class="text-base font-normal mb-2">About</a></li>
                        <li><a href="#" class="text-base font-normal mb-2">Frequently Asked Questions</a></li>
                    </ul>
                </div>
            </div>
        </div>
        <!-- Copyright -->
        <div class="border-t border-solid py-8" style="border-color: #ffffff24;">
            <div class="container mx-auto">
                <div class="flex flex-col sm:flex-row justify-between items-center">
                    <a href="#" class="mb-6 md:mb-0 inline-block"><img class="h-24 w-full" src="https://service-jobs-images.s3.us-east-2.amazonaws.com/wj5fk47d8y19y47rhv2x4ht9r24i"
                            alt=""></a>
                    <div class="text-base font-medium mb-6 md:mb-0 inline-block">&copy; 2024 Signature Roofing</div>
                    <div class="mt-4 sm:mt-0 flex space-x-4">
                        <a href="#" class="text-gray-500 hover:text-white">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                viewBox="0 0 320 512"><!--! Font Awesome Pro 6.5.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2024 Fonticons, Inc. -->
                                <path
                                    d="M80 299.3V512H196V299.3h86.5l18-97.8H196V166.9c0-51.7 20.3-71.5 72.7-71.5c16.3 0 29.4 .4 37 1.2V7.9C291.4 4 256.4 0 236.2 0C129.3 0 80 50.5 80 159.4v42.1H14v97.8H80z">
                                </path>
                            </svg>
                        </a>
                        <div class="flex items-center gap-3">
                            <a href="#"
                                class="h-8 w-8 flex items-center justify-center hoverBg transition-all duration-150"
                                style="background-color: #242424;">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 320 512">
                                    <path fill="#FFFFFF"
                                        d="M80 299.3V512H196V299.3h86.5l18-97.8H196V166.9c0-51.7 20.3-71.5 72.7-71.5 16.3 0 29.4 .4 37 1.2V7.9C291.4 4 256.4 0 236.2 0 129.3 0 80 50.5 80 159.4v42.1H14v97.8H80z" />
                                </svg>
                            </a>
                            <a href="#"
                                class="h-8 w-8 flex items-center justify-center hoverBg transition-all duration-150"
                                style="background-color: #242424;">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24">
                                    <path fill="#FFFFFF"
                                        d="M12 0c-3.292 0-3.708.014-5.003.072-1.294.058-2.183.246-2.963.53a6.006 6.006 0 0 0-2.18 1.433A6.006 6.006 0 0 0 .602 4.248c-.284.78-.472 1.669-.53 2.963C.014 8.506 0 8.922 0 12s.014 3.708.072 5.003c.058 1.294.246 2.183.53 2.963a6.006 6.006 0 0 0 1.433 2.18 6.006 6.006 0 0 0 2.18 1.433c.78.284 1.669.472 2.963.53C8.506 23.986 8.922 24 12 24s3.708-.014 5.003-.072c1.294-.058 2.183-.246 2.963-.53a6.006 6.006 0 0 0 2.18-1.433 6.006 6.006 0 0 0 1.433-2.18c.284-.78.472-1.669.53-2.963.058-1.295.072-1.711.072-5.003s-.014-3.708-.072-5.003c-.058-1.294-.246-2.183-.53-2.963a6.006 6.006 0 0 0-1.433-2.18A6.006 6.006 0 0 0 20.966.602c-.78-.284-1.669-.472-2.963-.53C15.708.014 15.292 0 12 0zm0 2.162c3.239 0 3.63.012 4.911.07 1.182.053 1.823.248 2.248.414.566.219.971.482 1.398.909.426.426.69.831.909 1.398.166.425.361 1.066.414 2.248.058 1.281.07 1.672.07 4.911s-.012 3.63-.07 4.911c-.053 1.182-.248 1.823-.414 2.248-.219.566-.482.971-.909 1.398-.426.426-.831.69-1.398.909-.425.166-1.066.361-2.248.414-1.281.058-1.672.07-4.911.07s-3.63-.012-4.911-.07c-1.182-.053-1.823-.248-2.248-.414a4.084 4.084 0 0 1-1.398-.909 4.084 4.084 0 0 1-.909-1.398c-.166-.425-.361-1.066-.414-2.248-.058-1.281-.07-1.672-.07-4.911s.012-3.63.07-4.911c.053-1.182.248-1.823.414-2.248a4.084 4.084 0 0 1 .909-1.398 4.084 4.084 0 0 1 1.398-.909c.425-.166 1.066-.361 2.248-.414C8.37 2.174 8.761 2.162 12 2.162zm0 3.505a6.333 6.333 0 0 0 0 12.666 6.333 6.333 0 0 0 0-12.666zm0 2.162a4.171 4.171 0 1 1 0 8.342 4.171 4.171 0 0 1 0-8.342zM18.406 3.8a1.49 1.49 0 1 0 0 2.98 1.49 1.49 0 0 0 0-2.98z" />
                                </svg>
                            </a>
                            <a href="#"
                                class="h-8 w-8 flex items-center justify-center hoverBg transition-all duration-150"
                                style="background-color: #242424;">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24">
                                    <path fill="#FFFFFF"
                                        d="M22.225 0H1.771C.792 0 0 .77 0 1.717V22.28C0 23.229.793 24 1.771 24h20.451C23.208 24 24 23.229 24 22.282V1.717C24 .77 23.208 0 22.225 0zM7.068 20.452H3.673V8.986h3.395v11.466zM5.371 7.646c-1.09 0-1.977-.903-1.977-2.015 0-1.11.885-2.013 1.977-2.013 1.09 0 1.976.903 1.976 2.013 0 1.112-.886 2.015-1.976 2.015zm15.082 12.806h-3.397v-5.572c0-1.33-.026-3.041-1.855-3.041-1.855 0-2.14 1.45-2.14 2.948v5.665h-3.397V8.986h3.261v1.561h.046c.454-.859 1.564-1.763 3.219-1.763 3.444 0 4.078 2.268 4.078 5.216v6.451z" />
                                </svg>
                            </a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <!-- End Copyright -->
    </footer>
    <!-- Footer Section -->

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js"></script>
    <script>
        $(document).ready(function () {
            $(".owl-carousel").owlCarousel({
                loop: true,
                margin: 10,
                nav: true,
                dots: true,
                autoplay: true,
                autoplayTimeout: 6000,
                autoplayHoverPause: true,
                responsive: {
                    0: {
                        items: 1
                    },
                    600: {
                        items: 2
                    },
                    1000: {
                        items: 3
                    }
                }
            });
        });
    </script>
    <script>
        function toggleAccordion(id) {
            const accordion = document.getElementById(`accordion${id}`);
            accordion.style.maxHeight = accordion.style.maxHeight ? null : `${accordion.scrollHeight}px`;
        }
    </script>
</body>

</html>
  HTML
)

puts "Seed data created successfully!"