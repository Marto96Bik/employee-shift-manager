/*
  Warnings:

  - The primary key for the `Store` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `Store` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `User` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `User` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `UserHierarchy` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `UserStore` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - Changed the type of `userId` on the `Shift` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `storeId` on the `Shift` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `ownerId` on the `Store` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `managerId` on the `UserHierarchy` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `employeeId` on the `UserHierarchy` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `userId` on the `UserStore` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `storeId` on the `UserStore` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- DropForeignKey
ALTER TABLE "Shift" DROP CONSTRAINT "Shift_storeId_fkey";

-- DropForeignKey
ALTER TABLE "Shift" DROP CONSTRAINT "Shift_userId_fkey";

-- DropForeignKey
ALTER TABLE "Store" DROP CONSTRAINT "Store_ownerId_fkey";

-- DropForeignKey
ALTER TABLE "UserHierarchy" DROP CONSTRAINT "UserHierarchy_employeeId_fkey";

-- DropForeignKey
ALTER TABLE "UserHierarchy" DROP CONSTRAINT "UserHierarchy_managerId_fkey";

-- DropForeignKey
ALTER TABLE "UserStore" DROP CONSTRAINT "UserStore_storeId_fkey";

-- DropForeignKey
ALTER TABLE "UserStore" DROP CONSTRAINT "UserStore_userId_fkey";

-- AlterTable
ALTER TABLE "Shift" DROP COLUMN "userId",
ADD COLUMN     "userId" INTEGER NOT NULL,
DROP COLUMN "storeId",
ADD COLUMN     "storeId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "Store" DROP CONSTRAINT "Store_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "ownerId",
ADD COLUMN     "ownerId" INTEGER NOT NULL,
ADD CONSTRAINT "Store_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "User" DROP CONSTRAINT "User_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
ADD CONSTRAINT "User_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "UserHierarchy" DROP CONSTRAINT "UserHierarchy_pkey",
DROP COLUMN "managerId",
ADD COLUMN     "managerId" INTEGER NOT NULL,
DROP COLUMN "employeeId",
ADD COLUMN     "employeeId" INTEGER NOT NULL,
ADD CONSTRAINT "UserHierarchy_pkey" PRIMARY KEY ("managerId", "employeeId");

-- AlterTable
ALTER TABLE "UserStore" DROP CONSTRAINT "UserStore_pkey",
DROP COLUMN "userId",
ADD COLUMN     "userId" INTEGER NOT NULL,
DROP COLUMN "storeId",
ADD COLUMN     "storeId" INTEGER NOT NULL,
ADD CONSTRAINT "UserStore_pkey" PRIMARY KEY ("userId", "storeId");

-- AddForeignKey
ALTER TABLE "Store" ADD CONSTRAINT "Store_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserStore" ADD CONSTRAINT "UserStore_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserStore" ADD CONSTRAINT "UserStore_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "Store"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserHierarchy" ADD CONSTRAINT "UserHierarchy_managerId_fkey" FOREIGN KEY ("managerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserHierarchy" ADD CONSTRAINT "UserHierarchy_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Shift" ADD CONSTRAINT "Shift_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Shift" ADD CONSTRAINT "Shift_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "Store"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
