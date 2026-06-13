import { config } from 'dotenv';
import { DataSource } from 'typeorm';
import * as bcrypt from 'bcryptjs';
import { Admin, AdminRole } from '../../modules/admins/entities/admin.entity';
import { EmergencyType } from '../../modules/emergency-types/entities/emergency-type.entity';
import { Service, ServiceCategory } from '../../modules/services/entities/service.entity';
import { FirstAidSeverity, FirstAidTopic } from '../../modules/first-aid/entities/first-aid-topic.entity';
import { FirstAidStep } from '../../modules/first-aid/entities/first-aid-step.entity';
import { FirstAidTranslation } from '../../modules/first-aid/entities/first-aid-translation.entity';
import { FirstAidStepTranslation } from '../../modules/first-aid/entities/first-aid-step-translation.entity';

config();

const dataSource = new DataSource({
  type: 'postgres',
  host: process.env.POSTGRES_HOST ?? 'localhost',
  port: parseInt(process.env.POSTGRES_PORT ?? '5432', 10),
  username: process.env.POSTGRES_USER ?? 'postgres',
  password: process.env.POSTGRES_PASSWORD ?? 'postgres',
  database: process.env.POSTGRES_DB ?? 'resq_kh',
  entities: [__dirname + '/../../**/*.entity{.ts,.js}'],
  synchronize: true,
});

async function seed() {
  await dataSource.initialize();
  console.log('Database connected. Seeding...');

  const adminRepo = dataSource.getRepository(Admin);
  const existingAdmin = await adminRepo.findOne({
    where: { email: 'admin@resq.kh' },
  });
  if (!existingAdmin) {
    await adminRepo.save(
      adminRepo.create({
        email: 'admin@resq.kh',
        password: await bcrypt.hash('Admin@123', 10),
        full_name: 'Super Admin',
        role: AdminRole.SUPER_ADMIN,
        is_active: true,
      }),
    );
    console.log('Created super admin: admin@resq.kh / Admin@123');
  }

  const emergencyTypeRepo = dataSource.getRepository(EmergencyType);
  const emergencyTypes = [
    { slug: 'police', label: 'Police', icon_name: 'police', color: '#1E40AF', sort_order: 1 },
    { slug: 'fire', label: 'Fire', icon_name: 'fire', color: '#DC2626', sort_order: 2 },
    { slug: 'medical', label: 'Medical', icon_name: 'medical', color: '#16A34A', sort_order: 3 },
    { slug: 'ambulance', label: 'Ambulance', icon_name: 'ambulance', color: '#EA580C', sort_order: 4 },
  ];
  for (const et of emergencyTypes) {
    const exists = await emergencyTypeRepo.findOne({ where: { slug: et.slug } });
    if (!exists) {
      await emergencyTypeRepo.save(emergencyTypeRepo.create(et));
    }
  }
  console.log('Emergency types seeded');

  const serviceRepo = dataSource.getRepository(Service);
  const services = [
    // ── Hospitals ──────────────────────────────────
    {
      name: 'Calmette Hospital',
      category: ServiceCategory.HOSPITAL,
      phone_number: '023426948',
      address: 'No. 3, Preah Monivong Blvd, Daun Penh, Phnom Penh',
      latitude: '11.581300',
      longitude: '104.915800',
      description: 'Largest public hospital in Phnom Penh with 24/7 emergency, surgery, ICU.',
    },
    {
      name: 'Khmer-Soviet Friendship Hospital',
      category: ServiceCategory.HOSPITAL,
      phone_number: '023217524',
      address: 'Yothapol Khemarak Phoumin Blvd (St. 271), Phnom Penh',
      latitude: '11.553000',
      longitude: '104.905000',
      description: 'Major public hospital with emergency, maternity, pediatrics.',
    },
    {
      name: 'Royal Phnom Penh Hospital',
      category: ServiceCategory.HOSPITAL,
      phone_number: '023991000',
      address: 'No. 888, Burman Avenue (St. 993), Sen Sok, Phnom Penh',
      latitude: '11.588000',
      longitude: '104.892000',
      description: 'International-standard private hospital with trauma center.',
    },
    {
      name: 'Preah Ang Duong Hospital',
      category: ServiceCategory.HOSPITAL,
      phone_number: '023218875',
      address: 'No. 118, Preah Norodom Blvd, Daun Penh, Phnom Penh',
      latitude: '11.564000',
      longitude: '104.924000',
      description: 'General hospital with emergency and specialist care.',
    },
    {
      name: 'Sen Sok International University Hospital',
      category: ServiceCategory.HOSPITAL,
      phone_number: '098729307',
      address: 'Phnom Penh Thmei, Khan Sen Sok, Phnom Penh',
      latitude: '11.595000',
      longitude: '104.885000',
      description: 'Teaching hospital with emergency and maternity services.',
    },
    // ── Police Stations ────────────────────────────
    {
      name: 'Phnom Penh Municipal Police',
      category: ServiceCategory.POLICE,
      phone_number: '117',
      address: 'No. 275, Preah Norodom Blvd, Daun Penh, Phnom Penh',
      latitude: '11.557000',
      longitude: '104.922000',
      description: 'Main police headquarters for Phnom Penh.',
    },
    {
      name: 'Tourist Police Headquarters',
      category: ServiceCategory.POLICE,
      phone_number: '0977780002',
      address: 'No. 275, Preah Norodom Blvd, Daun Penh, Phnom Penh',
      latitude: '11.556800',
      longitude: '104.921800',
      description: 'Specialized police unit for tourist assistance.',
    },
    {
      name: 'Chamkar Mon District Police',
      category: ServiceCategory.POLICE,
      phone_number: '023987701',
      address: 'Preah Norodom Blvd, corner of St. 294, Chamkar Mon, Phnom Penh',
      latitude: '11.543000',
      longitude: '104.921000',
      description: 'District police station serving Chamkar Mon area.',
    },
    {
      name: 'Toul Kork District Police',
      category: ServiceCategory.POLICE,
      phone_number: '023881612',
      address: 'St. 169, Toul Kork, Phnom Penh',
      latitude: '11.576000',
      longitude: '104.910000',
      description: 'District police station serving Toul Kork area.',
    },
    // ── Fire Stations ──────────────────────────────
    {
      name: 'Phnom Penh Fire Department HQ',
      category: ServiceCategory.FIRE_STATION,
      phone_number: '118',
      address: 'No. 58, St. 360, Sangkat Boeung Keng Kang, Phnom Penh',
      latitude: '11.549000',
      longitude: '104.918000',
      description: 'Central fire station with hazmat and rescue capabilities.',
    },
    {
      name: 'Daun Penh Fire Station',
      category: ServiceCategory.FIRE_STATION,
      phone_number: '011997296',
      address: 'Daun Penh District, Phnom Penh',
      latitude: '11.570000',
      longitude: '104.924000',
      description: 'Fire station covering the downtown Daun Penh area.',
    },
    {
      name: 'Toul Kork Fire Station',
      category: ServiceCategory.FIRE_STATION,
      phone_number: '118',
      address: 'Toul Kork District, Phnom Penh',
      latitude: '11.578000',
      longitude: '104.908000',
      description: 'Fire station serving northern Phnom Penh.',
    },
    // ── Ambulance Services ─────────────────────────
    {
      name: 'Calmette Ambulance (S.A.M.U.)',
      category: ServiceCategory.AMBULANCE,
      phone_number: '119',
      address: 'No. 3, Preah Monivong Blvd, Daun Penh, Phnom Penh',
      latitude: '11.581300',
      longitude: '104.915800',
      description: 'Emergency medical transport and critical care.',
    },
    {
      name: 'Khmer-Soviet Friendship Hospital Ambulance',
      category: ServiceCategory.AMBULANCE,
      phone_number: '023217764',
      address: 'Yothapol Khemarak Phoumin Blvd (St. 271), Phnom Penh',
      latitude: '11.553000',
      longitude: '104.905000',
      description: '24/7 emergency medical transport service.',
    },
    {
      name: 'Royal Phnom Penh Hospital Ambulance',
      category: ServiceCategory.AMBULANCE,
      phone_number: '023991000',
      address: 'No. 888, Burman Avenue, Sen Sok, Phnom Penh',
      latitude: '11.588000',
      longitude: '104.892000',
      description: 'Advanced life support ambulance service.',
    },
    // ── Contact / Helpline ─────────────────────────
    {
      name: 'Child Helpline Cambodia (CHC)',
      category: ServiceCategory.CONTACT,
      phone_number: '1280',
      address: 'Phnom Penh, Cambodia',
      latitude: '11.556400',
      longitude: '104.928200',
      description: '24/7 child protection, counseling, and abuse reporting.',
    },
    {
      name: 'Ministry of Health Hotline',
      category: ServiceCategory.CONTACT,
      phone_number: '115',
      address: 'No. 151-153, Preah Norodom Blvd, Phnom Penh',
      latitude: '11.556000',
      longitude: '104.921000',
      description: 'National health information and medical referral hotline.',
    },
  ];
  for (const s of services) {
    const exists = await serviceRepo.findOne({ where: { name: s.name } });
    if (!exists) {
      await serviceRepo.save(serviceRepo.create(s));
    }
  }
  console.log('Services seeded');

  const topicRepo = dataSource.getRepository(FirstAidTopic);
  const stepRepo = dataSource.getRepository(FirstAidStep);
  const topicTranslationRepo = dataSource.getRepository(FirstAidTranslation);
  const stepTranslationRepo = dataSource.getRepository(FirstAidStepTranslation);

  const topics = [
    {
      slug: 'cpr',
      icon_name: 'heart',
      sort_order: 1,
      severity: FirstAidSeverity.CRITICAL,
      title: 'CPR (Cardiopulmonary Resuscitation)',
      summary: 'Unconscious, not breathing, or only gasping.',
      steps: [
        {
          step_number: 1,
          is_warning: false,
          image_url: 'images/first_aid/cpr_step1.jpg',
          instruction: 'Tap shoulders firmly and shout "Are you okay?" If no response, call 119 immediately.',
        },
        {
          step_number: 2,
          is_warning: false,
          image_url: 'images/first_aid/cpr_step2.jpg',
          instruction: 'Place the heel of your hand on the center of the chest. Push hard and fast — at least 5cm deep, 100–120 times per minute.',
        },
        {
          step_number: 3,
          is_warning: false,
          image_url: 'images/first_aid/cpr_step3.jpg',
          instruction: 'After 30 compressions, tilt head back, lift chin, and give 2 rescue breaths lasting 1 second each.',
        },
        {
          step_number: 4,
          is_warning: true,
          image_url: 'images/first_aid/cpr_step4.jpg',
          instruction: 'Do NOT stop CPR until emergency services arrive or an AED becomes available.',
        },
      ],
    },
    {
      slug: 'bleeding',
      icon_name: 'blood',
      sort_order: 2,
      severity: FirstAidSeverity.CRITICAL,
      title: 'Severe Bleeding',
      summary: "Pulsing or steady flow of blood that won't stop.",
      steps: [
        {
          step_number: 1,
          is_warning: false,
          image_url: 'images/first_aid/bleeding_step1.jpg',
          instruction: 'Press firmly on the wound using a clean cloth. Maintain constant pressure — do not lift to check.',
        },
        {
          step_number: 2,
          is_warning: false,
          image_url: 'images/first_aid/bleeding_step2.jpg',
          instruction: 'Raise the injured area above the level of the heart to slow blood flow to the wound.',
        },
        {
          step_number: 3,
          is_warning: false,
          image_url: 'images/first_aid/bleeding_step3.jpg',
          instruction: 'Once bleeding slows, secure the cloth with a bandage. If blood soaks through, add more on top — do not remove.',
        },
        {
          step_number: 4,
          is_warning: true,
          image_url: 'images/first_aid/bleeding_step4.jpg',
          instruction: 'Do NOT remove an object embedded in a wound. Build padding around it instead — removing it can cause more bleeding.',
        },
      ],
    },
    {
      slug: 'choking',
      icon_name: 'warning',
      sort_order: 3,
      severity: FirstAidSeverity.URGENT,
      title: 'Choking',
      summary: 'Unable to speak, cough, or breathe effectively.',
      steps: [
        {
          step_number: 1,
          is_warning: false,
          image_url: 'images/first_aid/choking_step1.jpg',
          instruction: 'If the person can cough forcefully, encourage them to keep coughing. Only intervene if they cannot cough, speak, or breathe.',
        },
        {
          step_number: 2,
          is_warning: false,
          image_url: 'images/first_aid/choking_step2.jpg',
          instruction: 'Lean the person forward and give 5 firm blows between the shoulder blades with the heel of your hand.',
        },
        {
          step_number: 3,
          is_warning: false,
          image_url: 'images/first_aid/choking_step3.jpg',
          instruction: 'Stand behind the person, make a fist above the navel, and thrust inward and upward sharply. Repeat up to 5 times.',
        },
        {
          step_number: 4,
          is_warning: true,
          image_url: 'images/first_aid/choking_step4.jpg',
          instruction: 'Do NOT perform blind finger sweeps in the mouth. Only remove an object if you can clearly see it.',
        },
      ],
    },
    {
      slug: 'burns',
      icon_name: 'fire',
      sort_order: 4,
      severity: FirstAidSeverity.URGENT,
      title: 'Burns',
      summary: 'Skin damage from heat, chemicals, or electricity.',
      steps: [
        {
          step_number: 1,
          is_warning: false,
          image_url: 'images/first_aid/burn_step1.jpg',
          instruction: 'Cool the burn under cool (not cold) running water for at least 10 minutes.',
        },
        {
          step_number: 2,
          is_warning: false,
          image_url: 'images/first_aid/burn_step2.jpg',
          instruction: 'Remove jewelry or tight items near the burn before swelling occurs.',
        },
        {
          step_number: 3,
          is_warning: false,
          image_url: 'images/first_aid/burn_step3.jpg',
          instruction: 'Cover loosely with a clean non-fluffy material such as cling film or a clean plastic bag.',
        },
        {
          step_number: 4,
          is_warning: true,
          image_url: 'images/first_aid/burn_step4.jpg',
          instruction: 'Do NOT use ice, butter, or toothpaste on a burn. Do NOT burst any blisters.',
        },
      ],
    },
    {
      slug: 'fractures',
      icon_name: 'bone',
      sort_order: 5,
      severity: FirstAidSeverity.STABLE,
      title: 'Fractures',
      summary: 'Suspected broken bone — keep still and call for help.',
      steps: [
        {
          step_number: 1,
          is_warning: false,
          image_url: 'images/first_aid/fracture_step1.jpg',
          instruction: 'Keep the injured area still. Do not try to straighten the bone or push it back in.',
        },
        {
          step_number: 2,
          is_warning: false,
          image_url: 'images/first_aid/fracture_step2.jpg',
          instruction: 'Support the limb in the position found using a sling or improvised padding.',
        },
        {
          step_number: 3,
          is_warning: false,
          image_url: 'images/first_aid/fracture_step3.jpg',
          instruction: 'Apply ice wrapped in a cloth to reduce swelling. Do not apply ice directly to skin.',
        },
        {
          step_number: 4,
          is_warning: true,
          image_url: 'images/first_aid/fracture_step4.jpg',
          instruction: 'Do NOT give food or drink to the person in case they need surgery.',
        },
      ],
    },
  ];

  for (const t of topics) {
    // let topic = await topicRepo.findOne({ where: { slug: t.slug } });
    await topicRepo.delete({ slug: t.slug });
    const topic = await topicRepo.save(
      topicRepo.create({
        slug: t.slug,
        icon_name: t.icon_name,
        sort_order: t.sort_order,
        severity: t.severity as FirstAidSeverity,
      }),
    );
    // if (topic) {
    //   topic = await topicRepo.save(
    //     topicRepo.create({
    //       slug: t.slug,
    //       icon_name: t.icon_name,
    //       sort_order: t.sort_order,
    //       severity: t.severity as FirstAidSeverity,
    //     }),
    //   );
    await topicTranslationRepo.save(
      topicTranslationRepo.create({
        topic_id: topic!.id,
        language_code: 'en',
        title: t.title,
        summary: t.summary,
      }),
    );
    for (const s of t.steps) {
      const step = await stepRepo.save(
        stepRepo.create({
          topic_id: topic!.id,
          step_number: s.step_number,
          is_warning: 'is_warning' in s ? s.is_warning : false,
          image_url: s.image_url ?? null, 
        }),
      );
      await stepTranslationRepo.save(
        stepTranslationRepo.create({
          step_id: step.id,
          language_code: 'en',
          instruction: s.instruction,
        }),
      );
    }
  }
  console.log('First aid topics seeded');
  console.log('Seed completed successfully.');
  await dataSource.destroy();
}

seed().catch((err) => {
  console.error('Seed failed:', err);
  process.exit(1);
});
