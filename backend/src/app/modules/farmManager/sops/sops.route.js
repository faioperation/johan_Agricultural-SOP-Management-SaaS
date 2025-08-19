import { Router } from "express";
import { SOPController } from "./sops.controller.js";
import { checkAuthMiddleware } from "../../../middleware/checkAuthMiddleware.js";
import { Role } from "../../../utils/role.js";

const router = Router();

router.get(
  "/",
  checkAuthMiddleware(Role.FARM_ADMIN, Role.MANAGER),
  SOPController.getSopModules,
);

// 👇 SOP DETAIL (JSON or PDF)
router.get(
  "/detail/:sopId",
  checkAuthMiddleware(Role.FARM_ADMIN, Role.MANAGER),
  SOPController.getSOPDetail,
);

// 👇 SOP PDF DOWNLOAD
router.get(
  "/:sopId/download",
  checkAuthMiddleware(Role.FARM_ADMIN, Role.MANAGER),
  SOPController.downloadSop,
);

// 👇 SOP LIST BY MODULE (KEEP LAST)
router.get(
  "/:module",
  checkAuthMiddleware(Role.FARM_ADMIN, Role.MANAGER),
  SOPController.getSopsByModule,
);

export default router;
