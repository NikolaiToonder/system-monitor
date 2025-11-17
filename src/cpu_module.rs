use qmetaobject::*;
use crate::system_instance;

#[derive(Default, QObject)]

// Struct directly connected to the cpu module of the qml. 
pub struct CpuMonitor {
    //Base fields
    base: qt_base_class!(trait QObject),
    cpu_usage: qt_property!(f32; NOTIFY cpu_usage_changed),
    cpu_usage_core: qt_property!(QVariantList; NOTIFY cpu_usage_changed),

    //Signals
    cpu_usage_changed: qt_signal!(),
    
    //Functions
    update_usage: qt_method!(fn(&mut self, new_usage: f32)),
    request_update: qt_method!(fn(&mut self)),
}

impl CpuMonitor {
    fn update_usage(&mut self, new_usage: f32) {
        self.cpu_usage = new_usage;
        self.cpu_usage_changed();
    }

    // Function callable by the qml file!
    fn request_update(&mut self) {
        //Collect global core usage
        let global_usage = system_instance::get_global_cpu_usage();
        
        //Collect per-core usage
        let mut per_core_usage = Vec::new();
        for i in 0..system_instance::get_cpu_core_count() {
            if let Some(usage) = system_instance::get_cpu_core_usage(i) {
                per_core_usage.push(usage);
            }
        }
        
        self.update_usage(global_usage);
        
        self.cpu_usage_core = per_core_usage
            .into_iter()
            .map(|val| QVariant::from(val))
            .collect::<QVariantList>()
            .into();
    }
}
