-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "public"."Role" AS ENUM ('operator', 'player');

-- CreateEnum
CREATE TYPE "public"."GameState" AS ENUM ('lobby', 'in_progress', 'ended');

-- CreateEnum
CREATE TYPE "public"."RoundState" AS ENUM ('pending', 'active', 'closed');

-- CreateTable
CREATE TABLE "public"."Country" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Country_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Product" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."AppUser" (
    "id" SERIAL NOT NULL,
    "username" TEXT NOT NULL,
    "role" "public"."Role" NOT NULL,

    CONSTRAINT "AppUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."PlayerCountryAssignment" (
    "id" SERIAL NOT NULL,
    "gameId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "countryId" INTEGER NOT NULL,

    CONSTRAINT "PlayerCountryAssignment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Game" (
    "id" SERIAL NOT NULL,
    "totalRounds" INTEGER NOT NULL,
    "roundDurationSeconds" INTEGER NOT NULL,
    "state" "public"."GameState" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Game_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Round" (
    "id" SERIAL NOT NULL,
    "gameId" INTEGER NOT NULL,
    "roundNumber" INTEGER NOT NULL,
    "state" "public"."RoundState" NOT NULL,
    "startsAt" TIMESTAMP(3),
    "endsAt" TIMESTAMP(3),

    CONSTRAINT "Round_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Production" (
    "id" SERIAL NOT NULL,
    "gameId" INTEGER NOT NULL,
    "productId" INTEGER NOT NULL,
    "countryId" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,

    CONSTRAINT "Production_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Demand" (
    "id" SERIAL NOT NULL,
    "gameId" INTEGER NOT NULL,
    "productId" INTEGER NOT NULL,
    "countryId" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,

    CONSTRAINT "Demand_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."TariffRate" (
    "id" SERIAL NOT NULL,
    "gameId" INTEGER NOT NULL,
    "roundId" INTEGER NOT NULL,
    "productId" INTEGER NOT NULL,
    "fromCountryId" INTEGER NOT NULL,
    "toCountryId" INTEGER NOT NULL,
    "ratePercent" INTEGER NOT NULL,

    CONSTRAINT "TariffRate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ChatMessage" (
    "id" SERIAL NOT NULL,
    "gameId" INTEGER NOT NULL,
    "senderUserId" INTEGER NOT NULL,
    "toCountryId" INTEGER,
    "content" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ChatMessage_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Country_code_key" ON "public"."Country"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Country_name_key" ON "public"."Country"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Product_code_key" ON "public"."Product"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Product_name_key" ON "public"."Product"("name");

-- CreateIndex
CREATE UNIQUE INDEX "AppUser_username_key" ON "public"."AppUser"("username");

-- CreateIndex
CREATE UNIQUE INDEX "PlayerCountryAssignment_gameId_userId_key" ON "public"."PlayerCountryAssignment"("gameId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "PlayerCountryAssignment_gameId_countryId_key" ON "public"."PlayerCountryAssignment"("gameId", "countryId");

-- CreateIndex
CREATE UNIQUE INDEX "Round_gameId_roundNumber_key" ON "public"."Round"("gameId", "roundNumber");

-- CreateIndex
CREATE UNIQUE INDEX "Production_gameId_productId_countryId_key" ON "public"."Production"("gameId", "productId", "countryId");

-- CreateIndex
CREATE UNIQUE INDEX "Demand_gameId_productId_countryId_key" ON "public"."Demand"("gameId", "productId", "countryId");

-- CreateIndex
CREATE UNIQUE INDEX "TariffRate_gameId_roundId_productId_fromCountryId_toCountry_key" ON "public"."TariffRate"("gameId", "roundId", "productId", "fromCountryId", "toCountryId");

-- AddForeignKey
ALTER TABLE "public"."PlayerCountryAssignment" ADD CONSTRAINT "PlayerCountryAssignment_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "public"."Game"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PlayerCountryAssignment" ADD CONSTRAINT "PlayerCountryAssignment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."AppUser"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PlayerCountryAssignment" ADD CONSTRAINT "PlayerCountryAssignment_countryId_fkey" FOREIGN KEY ("countryId") REFERENCES "public"."Country"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Round" ADD CONSTRAINT "Round_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "public"."Game"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Production" ADD CONSTRAINT "Production_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "public"."Game"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Production" ADD CONSTRAINT "Production_productId_fkey" FOREIGN KEY ("productId") REFERENCES "public"."Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Production" ADD CONSTRAINT "Production_countryId_fkey" FOREIGN KEY ("countryId") REFERENCES "public"."Country"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Demand" ADD CONSTRAINT "Demand_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "public"."Game"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Demand" ADD CONSTRAINT "Demand_productId_fkey" FOREIGN KEY ("productId") REFERENCES "public"."Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Demand" ADD CONSTRAINT "Demand_countryId_fkey" FOREIGN KEY ("countryId") REFERENCES "public"."Country"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TariffRate" ADD CONSTRAINT "TariffRate_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "public"."Game"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TariffRate" ADD CONSTRAINT "TariffRate_roundId_fkey" FOREIGN KEY ("roundId") REFERENCES "public"."Round"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TariffRate" ADD CONSTRAINT "TariffRate_productId_fkey" FOREIGN KEY ("productId") REFERENCES "public"."Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TariffRate" ADD CONSTRAINT "TariffRate_fromCountryId_fkey" FOREIGN KEY ("fromCountryId") REFERENCES "public"."Country"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TariffRate" ADD CONSTRAINT "TariffRate_toCountryId_fkey" FOREIGN KEY ("toCountryId") REFERENCES "public"."Country"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ChatMessage" ADD CONSTRAINT "ChatMessage_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "public"."Game"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ChatMessage" ADD CONSTRAINT "ChatMessage_senderUserId_fkey" FOREIGN KEY ("senderUserId") REFERENCES "public"."AppUser"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ChatMessage" ADD CONSTRAINT "ChatMessage_toCountryId_fkey" FOREIGN KEY ("toCountryId") REFERENCES "public"."Country"("id") ON DELETE SET NULL ON UPDATE CASCADE;

