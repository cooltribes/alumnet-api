## Patch to solve the name conflicts #search
Ransack::Adapters::ActiveRecord::Base.class_eval('remove_method :search')