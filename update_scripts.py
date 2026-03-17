import os
import re

html_dir = r'D:\THÔNG\sneat-1.0.0\admin-ecommerce\html'
files = [f for f in os.listdir(html_dir) if f.endswith('.html')]

new_scripts_template = """    <!-- Core JS -->
    <script src="../assets/vendor/libs/jquery/jquery.js"></script>
    <script src="../assets/vendor/js/bootstrap.js"></script>
    <script src="../assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>
    <script src="../assets/vendor/js/menu.js"></script>
    <script src="../assets/js/main.js"></script>
    <script src="../assets/js/design-system.js"></script>
    <script src="../assets/js/ui-interactions.js"></script>"""

for filename in files:
    path = os.path.join(html_dir, filename)
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Identify the core JS range
    # Start: <!-- Core JS --> or jquery.js script tag
    start_match = re.search(r'(?:<!--\s*Core JS\s*-->.*?<script[^>]*?jquery\.js.*?>|<script[^>]*?jquery\.js.*?>)', content, re.DOTALL)
    if start_match:
        start_index = start_match.start()
        
        # End: the last core-related script tag
        end_search_content = content[start_index:]
        # We look for the last script tag that we consider part of the "core" block
        # This includes main.js, design-system.js, ui-interactions.js, menu.js, bootstrap.js, etc.
        # We also match the closing </script> tag.
        end_matches = list(re.finditer(r'<script[^>]*?(?:ui-interactions\.js|design-system\.js|main\.js|menu\.js|bootstrap\.js|popper\.js|perfect-scrollbar\.js|jquery\.js)[^>]*?>\s*</script>(\s*<!--\s*endbuild\s*-->)?', end_search_content))
        
        if end_matches:
            last_end_match = end_matches[-1]
            end_index = start_index + last_end_match.end()
            
            # Extract the range to be replaced
            old_block = content[start_index:end_index]
            
            # Find any script tags in old_block that are NOT in our core set
            other_tags = []
            for m in re.finditer(r'<script[^>]*?src=["\']([^"\']+)["\'][^>]*?>\s*</script>', old_block):
                src = m.group(1)
                is_core = any(lib in src for lib in ['jquery.js', 'popper.js', 'bootstrap.js', 'perfect-scrollbar.js', 'menu.js', 'main.js', 'design-system.js', 'ui-interactions.js'])
                if not is_core:
                    other_tags.append(m.group(0))
            
            replacement = new_scripts_template
            if other_tags:
                # Add a separator and the other tags
                replacement += "\n\n    <!-- Page Specific Libraries -->\n    " + "\n    ".join(other_tags)
            
            new_content = content[:start_index] + replacement + content[end_index:]
            
            with open(path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"Updated {filename}")
        else:
            print(f"Could not find end of block in {filename}")
    else:
        print(f"Could not find start of block in {filename}")
