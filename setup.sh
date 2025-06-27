#!/bin/bash

echo "🌟 Sakīnah App Setup Script 🌟"
echo "================================"
echo ""

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "📁 Creating .env file from .env.example..."
    cp .env.example .env
    echo "✅ .env file created!"
    echo ""
else
    echo "📁 .env file already exists."
    echo ""
fi

echo "🔧 Next steps to complete setup:"
echo ""
echo "1. Create a Supabase project at https://app.supabase.com"
echo "2. Get your project URL and anon key from Settings > API"
echo "3. Edit the .env file and replace the placeholder values:"
echo "   - SUPABASE_URL=https://your-project.supabase.co"
echo "   - SUPABASE_ANON_KEY=your_anon_key_here"
echo ""
echo "4. Run the following commands:"
echo "   flutter pub get"
echo "   flutter run"
echo ""
echo "📖 For more details, check the README.md file."
echo ""
echo "Happy coding! 🚀"
