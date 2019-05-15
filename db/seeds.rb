

admins = {
    daniel: {
        first_name: 'Daniel',
        last_name: 'Calderon',
        rut: '1111111-1',
        email: 'dcalderon@indoconsultores.cl',
        password: 'administrador',
        password_confirmation: 'administrador',
        role: 'administrador',
        client: 'none',
        info: 'Psicólogo de la Universidad Central de Chile. Especialista en Gestión por Competencias con un Diplomado en GPC de las Instituciones Públicas USACH. Ha organizado, relatado y evaluado  numerosos cursos en materias de Servicio al cliente, Relaciones Humanas, Liderazgo, Trabajo en equipo.'

    },
    admin: {
        first_name: 'Xavier',
        last_name: 'Domingo',
        rut: '16741261-0',
        email: 'xavier@it4.cl',
        password: 'administrador',
        password_confirmation: 'administrador',
        role: 'administrador',
        client: 'none'
    },
    demo: {
        first_name: 'John',
        last_name: 'Doe',
        rut: '22222222-2',
        email: 'demo@indovirtual.cl',
        password: 'demoindo',
        password_confirmation: 'demoindo',
        role: 'usuario',
        client: 'none'
    }
}

roles = {
    user: {
        role: 'usuario'
    },
    admin: {
        role: 'administrador'
    },
    teacher: {
        role: 'profesor'
    },
    coach: {
        role: 'coach'
    }
}
=begin

courses = {
    ev_desempeno: {
        name: 'Evaluación de Desempeño',
        description: 'Al finalizar el curso, los asistentes contarán con una metodología que les permitirá entender el valor de un proceso de evaluación de desempeño, con la finalidad de poder gestionar el rendimiento individual como del equipo.',
        category:  'eLearning',
        teacher_id: 1,
        creator_id: 1,
        hours: 10,
        all_subscribed:  true,
        publish: true,
        forum: 'IB45420141022033016'
    }
}

courses_modules = {
    module_1: {
        name: 'Evaluación de Desempeño',
        position: 1,
        course_id: 1,
    },
    module_2: {
        name: 'Retroalimentación Efectiva',
        position: 2,
        course_id: 1,
    }
}

module_items = {
    item_1: {
        title: '¿Qué es la evaluación del desempeño y para qué sirve?',
        course_id: 1,
        course_module_id: 1,
        media_type: 'powtoon',
        media_url: 'http://www.powtoon.com/embed/cDAtMlNvPrG/',
        position: 1,
        text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting",
        time_in_mins: 3,
        disqus_identifier: 'www'
    },
    item_2: {
        title: 'Normativa y procedimientos (generales)',
        course_id: 1,
        course_module_id: 1,
        media_type: 'powtoon',
        media_url: 'http://www.powtoon.com/embed/emx4zMoLyug/',
        position: 2,
        text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting",
        time_in_mins: 3,
        disqus_identifier: 'www'
    },
   item_3: {
      title: 'Ventajas e importancia de la EDD',
      course_id: 1,
      course_module_id: 1,
      media_type: 'youtube',
      media_url: 'http://www.youtube.com/embed/_PvaveDigMA',
      position: 3,
      text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting",
      time_in_mins: 3,
      disqus_identifier: 'www'
    },
    item_4: {
        title: 'Retroalimentación como una herramienta de aprendizaje',
        course_id: 1,
        course_module_id: 2,
        media_type: 'youtube',
        media_url: 'http://www.youtube.com/embed/_PvaveDigMA',
        position: 1,
        text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting",
        time_in_mins: 3,
        disqus_identifier: 'www'
    }
}
=end


admins.each do |user, data|
  user = User.new(data)
  unless User.where(email: user.email).exists?
    user.save!
  end
end

roles.each do |role, data|
  role = UserRoles.new(data)
  role.save!
end

=begin
courses.each do |course, data|
  course = Course.new(data)
  course.save!
end

courses_modules.each do |courses_module, data|
  module_item = CourseModule.new(data)
  module_item.save!
end

module_items.each do |module_item, data|
  module_item = ModuleItem.new(data)
  module_item.save!
end
=end
