import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://homrnzdgfxzypsxgbfaj.supabase.co';
const supabaseKey = 'sb_publishable_tyGIXmkXMidkJ5_G0A3qzw__s7OwOhC';

export const supabase = createClient(supabaseUrl, supabaseKey);
