import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import * as dotenv from 'dotenv';

dotenv.config();

const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  throw new Error('DATABASE_URL no está definida en .env');
}

const adapter = new PrismaPg({
  connectionString,
});

const prisma = new PrismaClient({ adapter });

async function main() {
  // Limpiar datos de las tablas
  await prisma.shift.deleteMany();
  await prisma.userHierarchy.deleteMany();
  await prisma.userStore.deleteMany();
  await prisma.store.deleteMany();
  await prisma.user.deleteMany();

  // Crear usuarios
  const alon = await prisma.user.create({
    data: {
      name: 'Alon',
      lastname: 'Alon',
      email: 'alon@empresa.com',
      password: 'hashed_password_example', // TODO: bcrypt
      role: 'OWNER',
    },
  });

  const martin = await prisma.user.create({
    data: {
      name: 'Martin',
      lastname: 'Martin',
      email: 'martin@empresa.com',
      password: 'hashed_password_example',
      role: 'EMPLOYEE',
    },
  });

  const moshe = await prisma.user.create({
    data: {
      name: 'Moshe',
      lastname: 'Moshe',
      email: 'moshe@empresa.com',
      password: 'hashed_password_example',
      role: 'EMPLOYEE',
    },
  });
  const lily = await prisma.user.create({
    data: {
      name: 'Lily',
      lastname: 'Lily',
      email: 'lily@empresa.com',
      password: 'hashed_password_example',
      role: 'EMPLOYEE',
    },
  });

  // Crear tiendas
  const sylviaPizza = await prisma.store.create({
    data: {
      name: 'Sylvia Pizza',
      owner: { connect: { id: alon.id } },
    },
  });

  // Asignar usuarios a tiendas
  await prisma.userStore.createMany({
    data: [
      { userId: martin.id, storeId: sylviaPizza.id },
      { userId: moshe.id, storeId: sylviaPizza.id },
      { userId: lily.id, storeId: sylviaPizza.id },
    ],
  });

  // Jerarquía ejemplo: Moshe es supervisor de Martin y Lily
  await prisma.userHierarchy.createMany({
    data: [
      { managerId: moshe.id, employeeId: martin.id },
      { managerId: moshe.id, employeeId: lily.id },
    ],
  });

  // 5. Ejemplos de turnos (solo owner y supervisores pueden crear)
  await prisma.shift.createMany({
    data: [
      {
        date: new Date('2025-12-23'),
        startTime: new Date('2025-12-23T07:00:00'),
        endTime: new Date('2025-12-23T15:00:00'),
        userId: moshe.id,
        storeId: sylviaPizza.id,
      },
      {
        date: new Date('2025-12-23'),
        startTime: new Date('2025-12-23T15:00:00'),
        endTime: new Date('2025-12-23T23:00:00'),
        userId: lily.id,
        storeId: sylviaPizza.id,
      },
      {
        date: new Date('2025-12-23'),
        startTime: new Date('2025-12-23T15:00:00'),
        endTime: new Date('2025-12-23T23:00:00'),
        userId: martin.id,
        storeId: sylviaPizza.id,
      },
    ],
  });

  console.log(
    'Seed completado: Alon (owner), Sylvia Pizza, y empleados asignados con jerarquía inventada',
  );
}

main()
  .catch((e) => {
    console.error('Error en seed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
